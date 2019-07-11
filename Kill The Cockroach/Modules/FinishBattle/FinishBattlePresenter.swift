//
//  FinishBattlePresenter.swift
//  Kill The Cockroach
//
//  Created by Fadilah Hasan on 09/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation

protocol FinishBattleViewPresenter: class {
    init(view: FinishBattleView)
    
    func setBattleStatus(_ status: EnumBattleStatus)
    func getBattleStatus() -> EnumBattleStatus
}

protocol FinishBattleView: class {
    // TODO: Declare view methods
}

class FinishBattlePresenter: FinishBattleViewPresenter {
    
    static func config(withFinishBattleViewController viewController: FinishBattleViewController) {
        let presenter = FinishBattlePresenter(view: viewController)
        viewController.presenter = presenter
    }
    
    let view: FinishBattleView
    var battleStatus: EnumBattleStatus = .win
    
    required init(view: FinishBattleView) {
        self.view = view
    }
    
    func setBattleStatus(_ status: EnumBattleStatus) {
        self.battleStatus = status
    }
    
    func getBattleStatus() -> EnumBattleStatus {
        return self.battleStatus
    }
}
