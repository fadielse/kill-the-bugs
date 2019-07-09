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
    func setSelectedTargetIndex(_ index: Int)
    func getSelectedTargetIndex() -> Int?
    func getObstacleCell(withIndex index: Int) -> ObstacleCollectionViewCell?
    func setIsPlayerHost(_ host: Bool)
    func getIsPlayerHost() -> Bool
    func setCocroachIndex(_ index: Int)
    func getCocroachIndex() -> Int
    func setIsMyTurn(_ isMyTurn: Bool)
    func getIsMyTurn() -> Bool
}

protocol BattleFieldView: class {
    // TODO: Declare view methods
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
    var isPlayerHost: Bool = false
    var cocroachIndex: Int = 0
    var isMyTurn: Bool = true
    
    required init(view: BattleFieldView) {
        self.view = view
    }
    
    func sendReadyToPlay() {
        gameService?.sendReadyToPlay(withPackage: GamePlay(type: .readyToPlay))
    }
    
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
}
