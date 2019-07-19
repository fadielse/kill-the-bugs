//
//  UIView+GlobalFrame.swift
//  Kill The Cockroach
//
//  Created by Fadilah Hasan on 08/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import UIKit

extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}
