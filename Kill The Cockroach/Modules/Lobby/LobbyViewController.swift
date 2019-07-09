//
//  LobbyViewController.swift
//  Kill The Cockroach
//
//  Created by fadielse on 05/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

extension SegueConstants {
    enum Lobby {
        static let jumpToBattleField = "jumpToBattleField"
    }
}

class LobbyViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startHostButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: LobbyPresenter!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LobbyPresenter.config(withLobbyViewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueConstants.Lobby.jumpToBattleField {
            let vc = segue.destination as! BattleFieldViewController
            vc.presenter.gameService = presenter.gameService
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.gameService.delegate = self
        
        setupView()
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.stopGameService()
        })
    }
    
    @IBAction func onStartHostButtonTapped(_ sender: Any) {
        presenter.startHost()
    }
    
    func setupView() {
        setupTableView()
        
        switch presenter.getPlayerType() {
        case .host:
            updateViewAsHost()
        case .client:
            updateViewAsClient()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func updateViewAsHost() {
        titleLabel.text = "Host a Game"
        startHostButton.isHidden = false
    }
    
    func updateViewAsClient() {
        titleLabel.text = "Join a Game"
        startHostButton.isHidden = true
        presenter.startBrowsePlayer()
    }
    
    func stopGameService() {
        presenter.gameService.stopHost()
        presenter.gameService.stopBrowse()
    }
}

extension LobbyViewController: LobbyView {
    // TODO: implement view methods
}

extension LobbyViewController: GameServiceDelegate {
    func GameService(deviceConnectingWithManager manager: GameService, connectedDevices: String) {
        print("Connecting to Opponent Player")
    }
    
    func GameService(deviceConnectedWithManager manager: GameService, connectedDevices: String) {
        print("Connected to Opponent Player")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: SegueConstants.Lobby.jumpToBattleField, sender: nil)
        }
    }
    
    func GameService(deviceConnectingFailedWithManager manager: GameService, connectedDevices: String) {
        print("Failed Connect to Opponent Player")
    }
    
    func GameService(sendAvaiblePlayers avaiblePlayers: [Player]) {
        presenter.avaiblePlayer = avaiblePlayers
        tableView.reloadData()
    }
}

extension LobbyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getAvaiblePlayerNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "playerCell")
        
        if let player = presenter.getAvaiblePlayer(withIndex: indexPath.row) {
            cell.textLabel?.text = player.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let player = presenter.getAvaiblePlayer(withIndex: indexPath.row) else {
            // TODO: Failed Invite
            return
        }
        
        presenter.invitePlayerToMatchMaking(withOpponentPlayer: player)
    }
}
