//
//  GamePlay.swift
//  Kill The Cockroach
//
//  Created by fadielse on 06/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation

struct GamePlay: Codable {
    var playerName: String?
    var type: EnumPackageType
    var targetPosition: Int?
    var targetIndex: Int?
    var isYourMove: Bool?
}
