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
    func startHost()
    func startBrowsePlayer()
    func getPlayerType() -> EnumPlayerType
    func getAvaiblePlayer() -> [Player]
    func getAvaiblePlayerNumber() -> Int
    func getAvaiblePlayer(withIndex index: Int) -> Player?
    func setPlayerName(_ name: String)
    func invitePlayerToMatchMaking(withOpponentPlayer opponentPlayer: Player)
}

protocol LobbyView: class {
    // TODO: Declare view methods
}

class LobbyPresenter: LobbyViewPresenter {
    
    static func config(withLobbyViewController viewController: LobbyViewController) {
        let presenter = LobbyPresenter(view: viewController)
        viewController.presenter = presenter
    }
    
    let view: LobbyView
    var playerType: EnumPlayerType = .host
    var player: Player?
    var gameService = GameService()
    var avaiblePlayer = [Player]()
    
    required init(view: LobbyView) {
        self.view = view
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
    
    func setPlayerName(_ name: String) {
        player = Player(name: name, peerId: nil)
        gameService.player = player
    }
    
    func startHost() {
        gameService.startHost()
    }
    
    func startBrowsePlayer() {
        gameService.startBrowse()
    }
    
    func invitePlayerToMatchMaking(withOpponentPlayer opponentPlayer: Player) {
        guard let peerId = opponentPlayer.peerId else {
            // TODO: error Invite
            return
        }
        
        gameService.invitePlayer(withPeerId: peerId)
    }
}
