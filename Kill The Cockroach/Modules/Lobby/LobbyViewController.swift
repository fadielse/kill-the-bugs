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
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UITextField!
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
            vc.presenter.setIsPlayerHost(presenter.playerType == .host)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        if let savedPlayer = presenter.getSavedPlayerName(), !savedPlayer.isEmpty, presenter.getPlayerType() == .client {
            presenter.startBrowsePlayer(withPlayerName: savedPlayer)
            
            let deadlineTime = DispatchTime.now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.presenter.gameService.delegate = self
            }
        }
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.stopGameService()
        })
    }
    
    @IBAction func onStartHostButtonTapped(_ sender: Any) {
        if let name = nameLabel.text, !name.isEmpty {
            startHostButton.isUserInteractionEnabled = false
            startHostButton.setImage(#imageLiteral(resourceName: "start-button-disable"), for: .normal)
            
            presenter.startHost(withPlayerName: name)
            
            let deadlineTime = DispatchTime.now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.presenter.gameService.delegate = self
            }
        } else {
            nameLabel.becomeFirstResponder()
        }
    }
    
    func setupView() {
        setupCloseButton()
        setupNameLabel()
        setupTableView()
        setupStartButton()
        
        switch presenter.getPlayerType() {
        case .host:
            updateViewAsHost()
        case .client:
            updateViewAsClient()
        }
    }
    
    func setupCloseButton() {
        closeButton.setImage(#imageLiteral(resourceName: "close-button-normal"), for: .normal)
        closeButton.setImage(#imageLiteral(resourceName: "close-button-click"), for: .highlighted)
    }
    
    func setupNameLabel() {
        nameLabel.delegate = self
        nameLabel.text = presenter.getSavedPlayerName()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupStartButton() {
        startHostButton.setImage(#imageLiteral(resourceName: "start-button-disable"), for: .normal)
        startHostButton.setImage(#imageLiteral(resourceName: "start-button-click"), for: .highlighted)
    }
    
    func updateViewAsHost() {
        titleLabel.text = "Host a Game"
        startHostButton.isHidden = false
        
        if presenter.isPlayerExists() {
            startHostButton.setImage(#imageLiteral(resourceName: "start-button-normal"), for: .normal)
        }
    }
    
    func updateViewAsClient() {
        titleLabel.text = "Join a Game"
        startHostButton.isHidden = true
        
        if !presenter.isPlayerExists() {
            nameLabel.becomeFirstResponder()
        }
    }
    
    func stopGameService() {
        if let _ = presenter.gameService {
            presenter.gameService.stopHost()
            presenter.gameService.stopBrowse()
        }
    }
}

extension LobbyViewController: LobbyView {
    func showLoading(withTitle title: String?) {
        showLoading(withView: self.view, andTitle: title)
    }
    
    func stopLoading() {
        hideLoading()
    }
}

extension LobbyViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch presenter.getPlayerType() {
        case .host:
            if let name = nameLabel.text, !name.isEmpty {
                startHostButton.setImage(#imageLiteral(resourceName: "start-button-normal"), for: .normal)
            } else {
                setupStartButton()
            }
        case .client:
            if let name = nameLabel.text, !name.isEmpty {
                presenter.startBrowsePlayer(withPlayerName: name)
                let deadlineTime = DispatchTime.now() + .milliseconds(500)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.presenter.gameService.delegate = self
                }
            } else {
                nameLabel.becomeFirstResponder()
            }
        }
    }
}

extension LobbyViewController: GameServiceDelegate {
    func GameService(deviceConnectingWithManager manager: GameService, connectedDevices: String) {
        print("Connecting to Opponent Player")
    }
    
    func GameService(deviceConnectedWithManager manager: GameService, connectedDevices: String) {
        print("Connected to Opponent Player")
        self.presenter.gameService.stopHost()
        self.presenter.gameService.stopBrowse()
        
        DispatchQueue.main.async {
            self.stopLoading()
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
            print("Avaible: \(player.name)")
            cell.textLabel?.text = player.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let player = presenter.getAvaiblePlayer(withIndex: indexPath.row) else {
            print("Avaible Player Not Found")
            return
        }
        
        if let name = nameLabel.text, !name.isEmpty {
            presenter.invitePlayerToMatchMaking(withOpponentPlayer: player)
        } else {
            nameLabel.becomeFirstResponder()
        }
    }
}
