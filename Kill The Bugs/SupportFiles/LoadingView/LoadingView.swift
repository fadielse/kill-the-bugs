//
//  LoadingView.swift
//  Kill The Cockroach
//
//  Created by Fadilah Hasan on 19/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    // MARK: Propery
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    func startLoadView(_ view: UIView, withTitle title: String?) {
        setupLoadingImage()
        
        loadingLabel.text = title
        
        self.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        self.center = view.center
        view.addSubview(self)
    }
    
    func stopLoadView() {
        loadingImage.stopAnimating()
    }
    
    func setupLoadingImage() {
        loadingImage.animationImages = [UIImage(named: "cockroach-loading-0")!, UIImage(named: "cockroach-loading-1")!, UIImage(named: "cockroach-loading-2")!]
        loadingImage.animationDuration = 0.3
        loadingImage.startAnimating()
    }
}
