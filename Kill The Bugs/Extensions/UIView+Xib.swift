//
//  UIView+Xib.swift
//  Kill The Cockroach
//
//  Created by Fadilah Hasan on 19/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import UIKit

extension UIView {
    class func instantiateFromNib<T: UIView>(_ viewType: T.Type) -> T {
        let url = URL(string: NSStringFromClass(viewType))
        return Bundle.main.loadNibNamed((url?.pathExtension)!, owner: nil, options: nil)!.first as! T
    }
    
    class func instantiateFromNib() -> Self {
        return instantiateFromNib(self)
    }
}
