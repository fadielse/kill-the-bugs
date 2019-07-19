//
//  HomePresenter.swift
//  Kill The Cockroach
//
//  Created by fadielse on 05/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation

protocol HomeViewPresenter: class {
    init(view: HomeView)
}

protocol HomeView: class {
    // TODO: Declare view methods
}

class HomePresenter: HomeViewPresenter {
    
    static func config(withHomeViewController viewController: HomeViewController) {
        let presenter = HomePresenter(view: viewController)
        viewController.presenter = presenter
    }
    
    let view: HomeView
    
    required init(view: HomeView) {
        self.view = view
    }
}
