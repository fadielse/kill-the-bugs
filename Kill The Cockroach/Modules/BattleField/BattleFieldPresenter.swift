//
//  BattleFieldPresenter.swift
//  Kill The Cockroach
//
//  Created by fadielse on 05/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation

protocol BattleFieldViewPresenter: class {
    init(view: BattleFieldView)
    
    func sendReadyToPlay()
    func sendPlayMove(withTargetIndex targetIndex: Int)
    func setSelectedTargetIndex(_ index: Int)
    func getSelectedTargetIndex() -> Int?
    func getObstacleCell(withIndex index: Int) -> ObstacleCollectionViewCell?
    func setIsPlayerHost(_ host: Bool)
    func getIsPlayerHost() -> Bool
    func setCocroachIndex(_ index: Int)
    func getCocroachIndex() -> Int
    func setIsMyTurn(_ isMyTurn: Bool)
    func getIsMyTurn() -> Bool
    func setReceiveDeclarationVictory(_ victory: Bool)
    func getReceiveDeclarationVictory() -> Bool
}

protocol BattleFieldView: class {
    func setupOpponentName()
}

class BattleFieldPresenter: BattleFieldViewPresenter {
    
    static func config(withBattleFieldViewController viewController: BattleFieldViewController) {
        let presenter = BattleFieldPresenter(view: viewController)
        viewController.presenter = presenter
    }
    
    let view: BattleFieldView
    var gameService: GameService?
    var selectedTargetIndex: Int?
    var destroyedObstacles = [Int]()
    var obstacleCells = [ObstacleCollectionViewCell]()
    var isPlayerHost: Bool = false {
        didSet {
            isMyTurn = isPlayerHost
        }
    }
    var cocroachIndex: Int = 0
    var isMyTurn: Bool = false
    var receiveDeclarationVictory: Bool = false
    var opponentPlayerName: String = "Anynomous" {
        didSet {
            view.setupOpponentName()
        }
    }
    
    required init(view: BattleFieldView) {
        self.view = view
    }
    
    // Game play method
    func sendReadyToPlay() {
        gameService?.sendGamePlayPackage(withPackage: GamePlay(playerName: UserDefaults.standard.object(forKey: UserDefaultConstant.playerInfo) as? String,
                                                               type: .readyToPlay,
                                                               targetPosition: cocroachIndex,
                                                               targetIndex: nil,
                                                               isYourMove: nil))
    }
    
    func sendSwitchPlayer() {
        if getIsMyTurn() {
            return
        }
        
        gameService?.sendGamePlayPackage(withPackage: GamePlay(playerName: opponentPlayerName,
                                                               type: .switchPlayerToMove,
                                                               targetPosition: nil,
                                                               targetIndex: nil,
                                                               isYourMove: true))
    }
    
    func sendPlayMove(withTargetIndex targetIndex: Int) {
        gameService?.sendGamePlayPackage(withPackage: GamePlay(playerName: opponentPlayerName,
                                                               type: .playerMove,
                                                               targetPosition: nil,
                                                               targetIndex: targetIndex,
                                                               isYourMove: nil))
    }
    
    func sendDeclarationOfVictory() {
        gameService?.sendGamePlayPackage(withPackage: GamePlay(playerName: opponentPlayerName,
                                                               type: .declarationOfVictory,
                                                               targetPosition: nil,
                                                               targetIndex: nil,
                                                               isYourMove: nil))
    }
    
    // End Game play method
    
    func setSelectedTargetIndex(_ index: Int) {
        selectedTargetIndex = index
    }
    
    func getSelectedTargetIndex() -> Int? {
        return selectedTargetIndex
    }
    
    func getObstacleCell(withIndex index: Int) -> ObstacleCollectionViewCell? {
        if obstacleCells.indices.contains(index) {
            return obstacleCells[index]
        }
        
        return nil
    }
    
    func setIsPlayerHost(_ host: Bool) {
        isPlayerHost = host
    }
    
    func getIsPlayerHost() -> Bool {
        return isPlayerHost
    }
    
    func setCocroachIndex(_ index: Int) {
        cocroachIndex = index
    }
    
    func getCocroachIndex() -> Int {
        return cocroachIndex
    }
    
    func isCocroachDesstroyed() -> Bool {
        return cocroachIndex == selectedTargetIndex
    }
    
    func setIsMyTurn(_ isMyTurn: Bool) {
        self.isMyTurn = isMyTurn
    }
    
    func getIsMyTurn() -> Bool {
        return isMyTurn
    }
    
    func setReceiveDeclarationVictory(_ victory: Bool) {
        self.receiveDeclarationVictory = victory
    }
    
    func getReceiveDeclarationVictory() -> Bool {
        return receiveDeclarationVictory
    }
}
