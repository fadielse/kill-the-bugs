//
//  HomeViewController.swift
//  Kill The Cockroach
//
//  Created by fadielse on 05/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation
import UIKit

extension SegueConstants {
    enum Home {
        static let jumpToLobby = "jumpToLobby"
    }
}

class HomeViewController: BaseViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var hostButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var cocroachImage: UIImageView!
    @IBOutlet weak var missileImage: UIImageView!
    
    var presenter: HomePresenter!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        HomePresenter.config(withHomeViewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if SegueConstants.Home.jumpToLobby == segue.identifier {
            if let vc = segue.destination as? LobbyViewController, let playerType = sender as? EnumPlayerType {
                vc.presenter.playerType = playerType
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        setupMissileImage()
        setupHostButton()
        setupJoinButton()
    }
    
    func setupMissileImage() {
        let image = UIImage(named: "missile")
        let rotatedImage = image?.rotate(radians: 180)
        
        missileImage.image = rotatedImage
    }
    
    func setupHostButton() {
        hostButton.setImage(#imageLiteral(resourceName: "host-button-normal"), for: .normal)
        hostButton.setImage(#imageLiteral(resourceName: "host-button-click"), for: .highlighted)
    }
    
    func setupJoinButton() {
        joinButton.setImage(#imageLiteral(resourceName: "join-button-normal"), for: .normal)
        joinButton.setImage(#imageLiteral(resourceName: "join-button-click"), for: .highlighted)
    }
    
    @IBAction func onHostButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: SegueConstants.Home.jumpToLobby, sender: EnumPlayerType.host)
    }
    
    @IBAction func onJoinButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: SegueConstants.Home.jumpToLobby, sender: EnumPlayerType.client)
    }
}

extension HomeViewController: HomeView {
    // TODO: implement view methods
}
