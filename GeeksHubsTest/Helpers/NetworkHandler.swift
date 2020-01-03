//
//  NetworkHandler.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 30/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI
import Combine

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
                    
                    if JSONResponse?["event"] as? String == "LOGIN" {
                        if let content = JSONResponse?["content"] as? [String: String], content["status"] == "logged" {
                            getInfo("USER")
                            getInfo("ROOMS")
                        } else {
                            gotError = true
                        }
                    } else if JSONResponse?["event"] as? String == "USER" {
                        let jsonData = try JSONSerialization.data(withJSONObject: JSONResponse?["content"] ?? [String: Any](), options: .prettyPrinted)
                        userInfo = jsonData
                    } else if JSONResponse?["event"] as? String == "ROOMS" {
                        let jsonData = try JSONSerialization.data(withJSONObject: JSONResponse?["content"] ?? [[String: Any]](), options: .prettyPrinted)
                        roomsInfo = jsonData
                    } else {
                        gotError = true
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
}
