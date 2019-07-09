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
    // TODO: Declare view presenter methods
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
    
    required init(view: FinishBattleView) {
        self.view = view
    }
    
    // TODO: Implement view presenter methods
}
