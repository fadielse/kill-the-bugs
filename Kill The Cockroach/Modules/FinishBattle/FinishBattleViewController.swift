//
//  FinishBattleViewController.swift
//  Kill The Cockroach
//
//  Created by Fadilah Hasan on 09/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation
import UIKit

extension SegueConstants {
    enum FinishBattle {
        // TODO: Add segue ids
    }
}

class FinishBattleViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var resultLabel: UILabel!
    
    var presenter: FinishBattlePresenter!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        FinishBattlePresenter.config(withFinishBattleViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = presenter.getBattleStatus() == .win ? "You Win" : "You Lose"
    }
    
    @IBAction func onExitButtonPressed(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
}

extension FinishBattleViewController: FinishBattleView {
    // TODO: implement view methods
}
