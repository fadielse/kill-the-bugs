//
//  BattleFieldViewController.swift
//  Kill The Cockroach
//
//  Created by fadielse on 05/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation
import UIKit

extension SegueConstants {
    enum BattleField {
        static let showFinishPopup = "ShowFinishPopup"
    }
}

class BattleFieldViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var missileImage: UIImageView!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerTurnImage: UIImageView!
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var opponentTurnImage: UIImageView!
    
    var presenter: BattleFieldPresenter!
    
    // MARK: Lifecycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueConstants.BattleField.showFinishPopup {
            let vc = segue.destination as! FinishBattleViewController
            vc.presenter.setBattleStatus(presenter.getReceiveDeclarationVictory() ? .lose : .win)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        BattleFieldPresenter.config(withBattleFieldViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.gameService?.battleDelegate = self
        
        if presenter.getIsPlayerHost() {
            prepareBattle()
        }
        
        showLoading(withView: self.view, andTitle: "Preparing...")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.presenter.sendReadyToPlay()
            self.setupView()
        }
    }
    
    func prepareBattle() {
        let cocroachIndex = Int.random(in: 0..<30)
        presenter.setCocroachIndex(cocroachIndex)
        
        print("Cocroach in: \(cocroachIndex)")
    }
    
    func setupView() {
        setupCollectionView()
        setupBottomView()
        setupTurnImageAnimation()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ObstacleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ObstacleCollectionViewCell")
    }
    
    func setupTurnImageAnimation() {
        let imagesToAnimate = [UIImage(named: "empty-button-normal")!, UIImage(named: "empty-button-disable")!]
        
        self.playerImage.animationImages = imagesToAnimate
        self.playerImage.animationDuration = 1.0
        
        self.opponentImage.animationImages = imagesToAnimate
        self.opponentImage.animationDuration = 1.0
    }
    
    func setupBottomView() {
        playerNameLabel.text = UserDefaults.standard.object(forKey: UserDefaultConstant.playerInfo) as? String
        opponentNameLabel.text = presenter.opponentPlayerName
    }
    
    func updateViewToStartBattle() {
        animateTurnImage()
        animateBlurBackground()
    }
    
    func animateTurnImage() {
        DispatchQueue.main.async {
            if self.presenter.getIsMyTurn() {
                self.opponentImage.stopAnimating()
                self.opponentTurnImage.isHidden = true
                self.opponentTurnImage.stopAnimating()
                self.playerImage.startAnimating()
                self.playerTurnImage.isHidden = false
                self.playerTurnImage.startAnimating()
            } else {
                self.playerImage.stopAnimating()
                self.playerTurnImage.isHidden = true
                self.playerTurnImage.stopAnimating()
                self.opponentImage.startAnimating()
                self.opponentTurnImage.isHidden = false
                self.opponentTurnImage.startAnimating()
            }
        }
    }
    
    func animateBlurBackground() {
        DispatchQueue.main.async {
            self.hideLoading()
            
            let blurEffect = UIBlurEffect(style: .regular)
            let effectView = UIVisualEffectView(effect: blurEffect)
            effectView.frame = self.backgroundImage.frame
            self.backgroundImage.addSubview(effectView)
            effectView.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                effectView.alpha = 1.0
            }
        }
    }
}

extension BattleFieldViewController: BattleFieldView {
    func setupOpponentName() {
        DispatchQueue.main.async {
            self.setupBottomView()
        }
    }
}

// MARK: GamePlay Method
extension BattleFieldViewController {
    func launchMissile(toTarget target: CGPoint) {
        let path = UIBezierPath()
        path.move(to: missileImage!.center)
        path.addLine(to: target)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = 0
        animation.duration = 0.5
        
        missileImage.isHidden = false
        missileImage.layer.add(animation, forKey: "animate rocket move to target")
        missileImage.center = target
        
        UIView.animate(withDuration: 0.6, animations: {
            self.missileImage.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
        }) { (success) in
            self.missileImage.transform =  .identity
            self.missileImage.isHidden = true
            self.animateExplodeCell()
        }
        
        collectionView.isUserInteractionEnabled = false
    }
    
    func animateExplodeCell() {
        if let selectedIndex = self.presenter.getSelectedTargetIndex(), let cell = self.presenter.getObstacleCell(withIndex: selectedIndex) {
            cell.obstacleImage.startAnimating()
            cell.obstacleImage.image = nil
            
            if presenter.isCocroachDesstroyed() {
                cell.obstacleImage.image = UIImage(named: "dead-cockroach")
                cell.obstacleImage.contentMode = .scaleAspectFit
                
                let deadlineTime = DispatchTime.now() + .milliseconds(1200)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.matchEnded()
                    self.presenter.sendDeclarationOfVictory()
                }
            } else {
                let deadlineTime = DispatchTime.now() + .milliseconds(1300)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.presenter.sendSwitchPlayer()
                    
                    let deadlineTime = DispatchTime.now() + .milliseconds(500)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        self.collectionView.isUserInteractionEnabled = true
                        self.animateTurnImage()
                    }
                }
            }
        }
    }
    
    func matchEnded() {
        performSegue(withIdentifier: "ShowFinishPopup", sender: nil)
    }
}

extension BattleFieldViewController: GameServiceBattleDelegate {
    func GameService(receiveGamePlayWithManager manager: GameService, andPackage package: Data) {
        do {
            // Decode data to object
            
            let jsonDecoder = JSONDecoder()
            let package = try jsonDecoder.decode(GamePlay.self, from: package)
            
            switch package.type {
            case .readyToPlay:
                print("Receive readyToPlay package")
                
                if let targetPosition = package.targetPosition, !presenter.getIsPlayerHost() {
                    print("Receive readyToPlay bugs position: \(targetPosition)")
                    
                    presenter.setCocroachIndex(targetPosition)
                }
                
                presenter.opponentPlayerName = package.playerName ?? presenter.opponentPlayerName
                print("Receive readyToPlay opponent name: \(presenter.opponentPlayerName)")
                updateViewToStartBattle()
            case .playerMove:
                print("Receive playerMove package")
                presenter.setSelectedTargetIndex(package.targetIndex!)
                
                if let selectedIndex = self.presenter.getSelectedTargetIndex(), let cell = self.presenter.getObstacleCell(withIndex: selectedIndex) {
                    let deadlineTime = DispatchTime.now() + .milliseconds(500)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        self.presenter.destroyedObstacles.append(selectedIndex)
                        self.launchMissile(toTarget: CGPoint(x: cell.globalFrame?.midX ?? 0, y: cell.globalFrame?.maxY ?? 0))
                    }
                } else {
                    print("Missing Target package")
                }
            case .switchPlayerToMove:
                print("Receive switchPlayerToMove package")
                presenter.setIsMyTurn(true)
                animateTurnImage()
            case .declarationOfVictory:
                print("Receive declarationOfVictory package")
                presenter.setReceiveDeclarationVictory(true)
                
                DispatchQueue.main.async {
                    self.matchEnded()
                }
            }
        }
        catch {
            print("Error on Decoding package")
        }
    }
}

extension BattleFieldViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObstacleCollectionViewCell", for: indexPath) as! ObstacleCollectionViewCell
        
        if let selectedIndex = presenter.getSelectedTargetIndex() {
            cell.aimImage.isHidden = !(selectedIndex == indexPath.row)
        }
        
        if presenter.obstacleCells.count < 30 {
            presenter.obstacleCells.append(cell)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        cell.alpha = 0
        
        UIView.beginAnimations("easeIn", context: nil)
        UIView.setAnimationDuration(TimeInterval(0.3))
        cell.transform = .identity
        cell.alpha = 1
        UIView.commitAnimations()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height / 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !presenter.getIsMyTurn() || presenter.destroyedObstacles.contains(indexPath.row) {
            return
        }
        
        presenter.setSelectedTargetIndex(indexPath.row)
        prepareToAttack()
    }
    
    func prepareToAttack() {
        presenter.setIsMyTurn(false)
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if let selectedIndex = self.presenter.getSelectedTargetIndex(), let cell = self.presenter.getObstacleCell(withIndex: selectedIndex) {
                cell.aimImage.isHidden = false
                let popTip = self.showAttackCommand(withView: self.view, andTargetView: cell.aimImage)
                
                popTip.tapHandler = { popTip in
                    print("Attaaackkkk!!!")
                    self.presenter.sendPlayMove(withTargetIndex: selectedIndex)
                    cell.aimImage.isHidden = true
                    self.presenter.destroyedObstacles.append(selectedIndex)
                    
                    self.launchMissile(toTarget: CGPoint(x: cell.globalFrame?.midX ?? 0, y: cell.globalFrame?.maxY ?? 0))
                }
                
                popTip.tapOutsideHandler = { popTip in
                    cell.aimImage.isHidden = true
                    self.presenter.setIsMyTurn(true)
                }
            }
        }
    }
}
