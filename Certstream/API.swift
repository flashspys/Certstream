//
//  API.swift
//  Certstream
//
//  Created by Felix Wehnert on 10.06.19.
//  Copyright © 2019 Felix Wehnert. All rights reserved.
//

import Foundation
import Starscream
import SwiftUI
import Combine

struct CertstreamEntryWrapper: Codable {
    let data: CertstreamEntry
}

struct CertstreamEntry: Codable, Identifiable {

    struct Cert: Codable {
        
        struct Subject: Codable {
            let CN: String
        }
        
        let all_domains: [String]?
        let fingerprint: String
        let serial_number: String
        let subject: Subject
        
        var domains: [String] {
            all_domains ?? []
        }
    }
    
    var id: Int {
        cert_index
    }
    
    let cert_index: Int
    let leaf_cert: Cert
    let chain: [Cert]
}

class API: BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    private let processingQueue = DispatchQueue(label: "apiProcessing", qos: .userInitiated)

    private let socket: WebSocket
    
    var certs = [CertstreamEntry]()
    
    var connected: Bool = false {
        didSet {
            didChange.send(())
        }
    }
    
    init() {
        socket = WebSocket(url: URL(string: "wss://certstream.calidog.io/")!)
        socket.delegate = self
        socket.connect()
    }
    
}

extension API: WebSocketDelegate {
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Got data?! Why?")
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        connected = true
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        connected = false
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        processingQueue.async {
            guard self.certs.count < 100 else {
                return
            }
            do {
                let entry = try JSONDecoder().decode(CertstreamEntryWrapper.self, from: text.data(using: .utf8)!)
                self.certs.insert(entry.data, at: 0)
                DispatchQueue.main.sync {
                    self.didChange.send(())
                }
                
            } catch {
                print(error)
            }
        }
    }
    
}
