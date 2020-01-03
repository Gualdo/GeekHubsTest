//
//  NetworkHandler.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 30/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI
import Combine

enum Event: String {
    case login = "LOGIN"
    case user = "USER"
    case rooms = "ROOMS"
    case messages = "MESSAGES"
}

class NetworkHanlder: ObservableObject {
    
    var objectWillChange = PassthroughSubject<NetworkHanlder, Never>()
    
    var isInfoCopleted: Bool = false {
        willSet {
            if newValue == true {
                objectWillChange.send(self)
            }
        }
    }
    
    var gotError: Bool = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var messages: Data? = nil {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var userInfo: Data? = nil {
        didSet {
            isInfoCopleted = roomsInfo != nil
        }
    }
    var roomsInfo: Data? = nil {
        didSet {
            isInfoCopleted = userInfo != nil
        }
    }
    
    let socket = WebSocket("wss://api.cryptysecure-dev.com/ws/cryptytalk/")
    
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
            self.gotError = true
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
                    let event: Event = Event(rawValue: JSONResponse?["event"] as! String)!
                    
                    switch event {
                    case .login:
                        if let content = JSONResponse?["content"] as? [String: String], content["status"] == "logged" {
                            getInfo("USER")
                            getInfo("ROOMS")
                        } else {
                            gotError = true
                        }
                    case .user:
                        let jsonData = try JSONSerialization.data(withJSONObject: JSONResponse?["content"] ?? [String: Any](), options: .prettyPrinted)
                        userInfo = jsonData
                    case .rooms:
                        let jsonData = try JSONSerialization.data(withJSONObject: JSONResponse?["content"] ?? [[String: Any]](), options: .prettyPrinted)
                        roomsInfo = jsonData
                    case .messages:
                        let jsonData = try JSONSerialization.data(withJSONObject: JSONResponse?["content"] ?? [[String: Any]](), options: .prettyPrinted)
                        messages = jsonData
                    }
                } catch {
                    gotError = true
                }
            }
        } else {
            gotError = true
        }
    }
    
    fileprivate func dictionaryToString(_ JSONDictionary: [String: AnyObject]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: JSONDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let string = String(data: jsonData, encoding: String.Encoding.utf8){
                return string
            } else {
                gotError = true
                return nil
            }
        } catch {
            gotError = true
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
    
    func getMessages(_ JSONDictionary: [String: AnyObject]) {
        guard let string = dictionaryToString(JSONDictionary) else { return }
        self.socket.send(string)
    }
}
