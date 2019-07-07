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
