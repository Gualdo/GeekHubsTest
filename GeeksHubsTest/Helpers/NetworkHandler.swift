//
//  NetworkHandler.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 30/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI
import Combine

protocol ResponseHandler {
    func errorReceived()
    func userInfoReceived(_ JSONResponse: [String: Any])
    func roomsInfoReceived(_ JSONResponse: [[String: Any]])
}

class NetworkHanlder: ObservableObject {
    
    var objectWillChange = PassthroughSubject<NetworkHanlder, Never>()
    
    static let current = NetworkHanlder()
    let socket = WebSocket("wss://api.cryptysecure-dev.com/ws/cryptytalk/")
    var delegate: ResponseHandler?
    
    init() {
        setupSocket()
        self.socket.open()
    }
    
    fileprivate func setupSocket() {
        socket.event.open = {
            print("opened")
        }
         
        socket.event.close = { code, reason, clean in
            print("closed")
        }
         
        socket.event.error = { error in
            self.delegate?.errorReceived()
        }
         
        socket.event.message = { message in
            self.handleMessage(jsonString: message)
        }
    }
    
    fileprivate func handleMessage(jsonString: Any) {
        if let text = jsonString as? String {
            if let data = text.data(using: .utf8) {
                do {
                    let JSONResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
                    
                    if JSONResponse?["event"] as? String == "LOGIN" {
                        if let content = JSONResponse?["content"] as? [String: String], content["status"] == "logged" {
                            getInfo("USER")
                            getInfo("ROOMS")
                        } else {
                            delegate?.errorReceived()
                        }
                    } else if JSONResponse?["event"] as? String == "USER" {
                        if let content = JSONResponse?["content"] as? [String: Any] {
                            delegate?.userInfoReceived(content)
                        } else {
                            delegate?.errorReceived()
                        }
                    } else if JSONResponse?["event"] as? String == "ROOMS" {
                        if let content = JSONResponse?["content"] as? [[String: Any]] {
                            delegate?.roomsInfoReceived(content)
                        } else {
                            delegate?.errorReceived()
                        }
                    } else {
                        delegate?.errorReceived()
                    }
                    
                } catch {
                    delegate?.errorReceived()
                }
            }
        } else {
            delegate?.errorReceived()
        }
    }
    
    fileprivate func dictionaryToString(_ JSONDictionary: [String: AnyObject]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: JSONDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let string = String(data: jsonData, encoding: String.Encoding.utf8){
                return string
            } else {
                delegate?.errorReceived()
                return nil
            }
        } catch {
            delegate?.errorReceived()
            return nil
        }
    }
    
    fileprivate func getInfo(_ section: String) {
        var JSONDictionary = [String: AnyObject]()
        JSONDictionary["cmd"] = section as AnyObject
        guard let string = dictionaryToString(JSONDictionary) else { return }
        self.socket.send(string)
        
    }
    
    func doLogin(_ JSONDictionary: [String: AnyObject]) {
        guard let string = dictionaryToString(JSONDictionary) else { return }
        self.socket.send(string)
    }
}
