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
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var missileImage: UIImageView!
    
    var presenter: BattleFieldPresenter!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        BattleFieldPresenter.config(withBattleFieldViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        presenter.gameService?.battleDelegate = self
//        presenter.sendReadyToPlay()
        
        presenter.setIsPlayerHost(true)
        if presenter.getIsPlayerHost() {
            prepareBattle()
        }
        
        setupCollectionView()
    }
    
    func prepareBattle() {
        let cocroachIndex = Int.random(in: 0..<40)
        presenter.setCocroachIndex(cocroachIndex)
        
        print("Cocroach in: \(cocroachIndex)")
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ObstacleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ObstacleCollectionViewCell")
    }
    
    func updateViewToStartBattle() {
    }
}

extension BattleFieldViewController: BattleFieldView {
    // TODO: implement view methods
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
        animation.duration = 2.0
        
        missileImage.layer.add(animation, forKey: "animate rocket move to target")
        missileImage.center = target
        
        UIView.animate(withDuration: 2.0, animations: {
            self.missileImage.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
        }) { (success) in
            self.missileImage.transform = .identity
            self.animateExplodeCell()
        }
    }
    
    func animateExplodeCell() {
        if let selectedIndex = self.presenter.getSelectedTargetIndex(), let cell = self.presenter.getObstacleCell(withIndex: selectedIndex) {
            cell.obstacleImage.startAnimating()
            cell.obstacleImage.image = nil
            
            if presenter.isCocroachDesstroyed() {
                cell.obstacleImage.image = UIImage(named: "dead-cockroach")
                cell.obstacleImage.contentMode = .scaleAspectFit
                
                let deadlineTime = DispatchTime.now() + .seconds(3)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.matchEnded()
                }
            }
            
            presenter.setIsMyTurn(true)
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
            
            updateViewToStartBattle()
        }
        catch {
            print("Error on Decoding package")
        }
    }
}

extension BattleFieldViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObstacleCollectionViewCell", for: indexPath) as! ObstacleCollectionViewCell
        
        if let selectedIndex = presenter.getSelectedTargetIndex() {
            cell.aimImage.isHidden = !(selectedIndex == indexPath.row)
        }
        
        if presenter.obstacleCells.count < 40 {
            presenter.obstacleCells.append(cell)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height / 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !presenter.getIsMyTurn() {
            return
        }
        
        presenter.setIsMyTurn(false)
        presenter.setSelectedTargetIndex(indexPath.row)
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if let selectedIndex = self.presenter.getSelectedTargetIndex(), let cell = self.presenter.getObstacleCell(withIndex: selectedIndex) {
                cell.aimImage.isHidden = false
                let popTip = self.showAttackCommand(withView: self.view, andTargetView: cell.aimImage)
                
                popTip.tapHandler = { popTip in
                    print("Attaaackkkk!!!")
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
