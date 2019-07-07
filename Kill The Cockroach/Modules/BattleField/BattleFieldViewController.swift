//
//  BattleFieldViewController.swift
//  Kill The Cockroach
//
//  Created by fadielse on 05/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation
import UIKit

extension SegueConstants {
    enum BattleField {
        // TODO: Add segue ids
    }
}

class BattleFieldViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var presenter: BattleFieldPresenter!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        BattleFieldPresenter.config(withBattleFieldViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.gameService?.battleDelegate = self
        presenter.sendReadyToPlay()
    }
    
    @IBAction func onTestButtonPressed(_ sender: Any) {
        presenter.gameService?.sendReadyToPlay(withPackage: GamePlay(type: .readyToPlay))
    }
}

extension BattleFieldViewController: BattleFieldView {
    // TODO: implement view methods
}

extension BattleFieldViewController: GameServiceBattleDelegate {
    func GameService(receiveGamePlayWithManager manager: GameService, andPackage package: Data) {
        do {
            // Decode data to object
            
            let jsonDecoder = JSONDecoder()
            let package = try jsonDecoder.decode(GamePlay.self, from: package)
            
            
            statusLabel.text = "ready"
        }
        catch {
            print("Error on Decoding package")
        }
    }
}
