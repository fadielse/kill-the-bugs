//
//  ObstacleCollectionViewCell.swift
//  Kill The Cockroach
//
//  Created by Fadilah Hasan on 08/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import UIKit

class ObstacleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var obstacleImage: UIImageView!
    @IBOutlet weak var aimImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var images = [UIImage]()
        for number in 1...25 {
            if let iv = UIImage(named: "bom-atom_\(number)") {
                images.append(iv)
            }
        }
        
        for number in (1...5).reversed() {
            if let iv = UIImage(named: "tree-sprites_\(number)") {
                images.append(iv)
            }
        }
        
        obstacleImage.animationImages = images
        obstacleImage.animationDuration = 1.2
        obstacleImage.animationRepeatCount = 1
    }

}
