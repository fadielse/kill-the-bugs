//
//  Player.swift
//  Kill The Cockroach
//
//  Created by fadielse on 05/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Player: NSObject {
    var name: String = "Anynomous"
    var peerId: MCPeerID?
    
    init(name: String, peerId: MCPeerID?) {
        self.name = name
        self.peerId = peerId
    }
    
    func getInfoForService() -> [String: String] {
        return ["name": name]
    }
}
