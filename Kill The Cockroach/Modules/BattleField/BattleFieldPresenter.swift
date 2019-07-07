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
    
    required init(view: BattleFieldView) {
        self.view = view
    }
    
    func sendReadyToPlay() {
        gameService?.sendReadyToPlay(withPackage: GamePlay(type: .readyToPlay))
    }
}
