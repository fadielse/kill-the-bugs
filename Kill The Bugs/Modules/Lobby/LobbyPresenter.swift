//
//  LobbyPresenter.swift
//  Kill The Cockroach
//
//  Created by fadielse on 05/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation

protocol LobbyViewPresenter: class {
    init(view: LobbyView)
    func startHost(withPlayerName playerName: String)
    func startBrowsePlayer(withPlayerName name: String)
    func getSavedPlayerName() -> String?
    func getPlayerType() -> EnumPlayerType
    func getAvaiblePlayer() -> [Player]
    func getAvaiblePlayerNumber() -> Int
    func getAvaiblePlayer(withIndex index: Int) -> Player?
    func invitePlayerToMatchMaking(withOpponentPlayer opponentPlayer: Player)
    func isPlayerExists() -> Bool
}

protocol LobbyView: class {
    func showLoading(withTitle title: String?)
    func stopLoading()
}

class LobbyPresenter: LobbyViewPresenter {
    
    static func config(withLobbyViewController viewController: LobbyViewController) {
        let presenter = LobbyPresenter(view: viewController)
        viewController.presenter = presenter
    }
    
    let view: LobbyView
    var playerType: EnumPlayerType = .host
    var gameService: GameService!
    var avaiblePlayer = [Player]()
    
    required init(view: LobbyView) {
        self.view = view
    }
    
    func getSavedPlayerName() -> String? {
        guard let savedPlayer = UserDefaults.standard.object(forKey: UserDefaultConstant.playerInfo) as? String else {
            return nil
        }
        
        return savedPlayer
    }
    
    func getPlayerType() -> EnumPlayerType {
        return playerType
    }
    
    func getAvaiblePlayer() -> [Player] {
        return avaiblePlayer
    }
    
    func getAvaiblePlayerNumber() -> Int {
        return avaiblePlayer.count
    }
    
    func getAvaiblePlayer(withIndex index: Int) -> Player? {
        if avaiblePlayer.indices.contains(index) {
            return avaiblePlayer[index]
        }
        
        return nil
    }
    
    func startHost(withPlayerName name: String) {
        savePlayer(withPlayerName: name)
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.gameService = GameService()
            self.gameService.startHost()
        }
    }
    
    func startBrowsePlayer(withPlayerName name: String) {
        savePlayer(withPlayerName: name)
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.gameService = GameService()
            self.gameService.startBrowse()
        }
    }
    
    func invitePlayerToMatchMaking(withOpponentPlayer opponentPlayer: Player) {
        guard let peerId = opponentPlayer.peerId else {
            // TODO: error Invite
            return
        }
        
        view.showLoading(withTitle: "Connecting...")
        gameService.invitePlayer(withPeerId: peerId)
    }
    
    func savePlayer(withPlayerName playerName: String) {
        UserDefaults.standard.set(playerName, forKey: UserDefaultConstant.playerInfo)
        UserDefaults.standard.synchronize()
    }
    
    func isPlayerExists() -> Bool {
        guard let savedPlayer = UserDefaults.standard.object(forKey: UserDefaultConstant.playerInfo) as? String else {
            return false
        }
        
        return !savedPlayer.isEmpty
    }
}
