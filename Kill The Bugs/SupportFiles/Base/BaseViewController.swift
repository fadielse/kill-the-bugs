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
        popTip.show(text: "Attack!", direction: .up, maxWidth: 200, in: view, from: targetView.globalFrame!, duration: nil)
        
        return popTip
    }
    
    func showLoading(withView view: UIView, andTitle title: String?) {
        loadingView?.startLoadView(view, withTitle: title)
    }
    
    func hideLoading() {
        loadingView?.removeFromSuperview()
    }
}
