//
//  BaseViewController.swift
//  Kill The Cockroach
//
//  Created by fadielse on 05/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import UIKit
import AMPopTip

class BaseViewController: UIViewController {
    
    var loadingView: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView = LoadingView.instantiateFromNib()
    }
    
    deinit {
        loadingView?.removeFromSuperview()
        loadingView = nil
        print("Deinit ViewController")
    }
    
    @discardableResult
    func showAttackCommand(withView view: UIView, andTargetView targetView: UIView) -> PopTip {
        let popTip = PopTip()
        popTip.cornerRadius = 22.0
        popTip.padding = 0
        popTip.bubbleColor = .white
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 44.0))
        let attackButton = UIImageView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 44.0))
        attackButton.animationImages = [UIImage(named: "empty-button-normal")!, UIImage(named: "empty-button-click")!]
        attackButton.animationDuration = 1.5
        attackButton.startAnimating()
        let attackLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 90.0, height: 34.0))
        attackLabel.font = UIFont(name: "VIDEOPHREAK", size: 15.0)
        attackLabel.textAlignment = .center
        attackLabel.textColor = .white
        attackLabel.shadowColor = .darkGray
        attackLabel.text = "ATTACK!"
        
        customView.addSubview(attackButton)
        customView.addSubview(attackLabel)
        
        popTip.show(customView: customView, direction: .up, in: view, from: targetView.globalFrame!)
        
        return popTip
    }
    
    func showLoading(withView view: UIView, andTitle title: String?) {
        loadingView?.startLoadView(view, withTitle: title)
    }
    
    func hideLoading() {
        loadingView?.removeFromSuperview()
    }
}
