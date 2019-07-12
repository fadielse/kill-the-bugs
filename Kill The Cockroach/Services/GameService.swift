//
//  GameService.swift
//  Kill The Cockroach
//
//  Created by fadielse on 05/07/19.
//  Copyright © 2019 Fadilah Hasan. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol GameServiceDelegate {
    
    func GameService(sendAvaiblePlayers avaiblePlayers: [Player])
    func GameService(deviceConnectingWithManager manager: GameService, connectedDevices: String)
    func GameService(deviceConnectedWithManager manager: GameService, connectedDevices: String)
    func GameService(deviceConnectingFailedWithManager manager: GameService, connectedDevices: String)
    
}

protocol GameServiceBattleDelegate {
    func GameService(receiveGamePlayWithManager manager: GameService, andPackage package: Data)
}

class GameService: NSObject {
    
    private let gameServiceType = "fadielse-game"
    
    private var myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private var avaiblePlayer = [Player]()
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    var delegate: GameServiceDelegate?
    var battleDelegate: GameServiceBattleDelegate?
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    override init() {
        let player = Player(name: UserDefaults.standard.string(forKey: UserDefaultConstant.playerInfo) ?? "Anynomous", peerId: nil)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: player.getInfoForService(), serviceType: gameServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: gameServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
}

// MARK: Lobby Game Service
extension GameService {
    func startHost() {
        self.serviceAdvertiser.startAdvertisingPeer()
    }
    
    func stopHost() {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func startBrowse() {
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    func stopBrowse() {
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func invitePlayer(withPeerId peerId: MCPeerID) {
        serviceBrowser.invitePeer(peerId, to: self.session, withContext: nil, timeout: 10)
    }
}

// MARK: Battle Ground Service
extension GameService {
    func sendGamePlayPackage(withPackage package: GamePlay) {
        NSLog("%@", "packages to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(package)
                let str = String(decoding: data, as: UTF8.self)
                print(str)
                do {
                    try self.session.send(data, toPeers: session.connectedPeers, with: .reliable)
                }
                catch let error {
                    NSLog("%@", "Error for sending: \(error)")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension GameService : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
}

extension GameService : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        
        avaiblePlayer.append(Player(name: info?["name"] ?? "Anynomous", peerId: peerID))
        delegate?.GameService(sendAvaiblePlayers: avaiblePlayer)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
        
        guard let indexToRemove = avaiblePlayer.firstIndex(where: { $0.peerId == peerID }) else {
            return
        }
        
        avaiblePlayer.remove(at: indexToRemove)
        delegate?.GameService(sendAvaiblePlayers: avaiblePlayer)
    }
}

extension GameService : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        
        switch state {
        case .connecting:
            self.delegate?.GameService(deviceConnectingWithManager: self, connectedDevices: peerID.displayName)
        case .connected:
            self.delegate?.GameService(deviceConnectedWithManager: self, connectedDevices: peerID.displayName)
        case .notConnected:
            self.delegate?.GameService(deviceConnectingFailedWithManager: self, connectedDevices: peerID.displayName)
        @unknown default:
            print("Unknown state")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        
        self.battleDelegate?.GameService(receiveGamePlayWithManager: self, andPackage: data)
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}
