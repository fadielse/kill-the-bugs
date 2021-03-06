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
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var resultImage: UIImageView!
    
    var presenter: FinishBattlePresenter!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        FinishBattlePresenter.config(withFinishBattleViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.resultLabel.text = self.presenter.getBattleStatus() == .win ? "You Win" : "You Lose"
            self.resultImage.image = self.presenter.getBattleStatus() == .win ?
                #imageLiteral(resourceName: "immune-cocroach") : #imageLiteral(resourceName: "lose-cockroach")
            self.exitButton.setTitle("Exit", for: .normal)
        }
    }
    
    @IBAction func onExitButtonPressed(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
}

extension FinishBattleViewController: FinishBattleView {
    // TODO: implement view methods
}
