//
//  ChatMOdel.swift
//  GeeksHubsTest
//
//  Created by  WB-Assetstudio on 03/01/2020.
//  Copyright © 2020 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct Message {
    var id: String?
    var room: String?
    var username: String?
    var avatar: String?
    var createdAt: String?
}

class ChatModel  {
    
    @ObservedObject var manager: NetworkHanlder
    
    var rooms: [Room]?
    
    var view: RoomsList?
    
    init(manager: NetworkHanlder) {
        self.manager = manager
        guard let data = manager.roomsInfo else { return }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.rooms = try decoder.decode([Room].self, from: data)
        } catch let jsonError {
            print("Failed to decode:", jsonError)
        }
//        self.configureView()
    }
    
//    fileprivate func configureView() {
//        self.view = RoomsList(roomsModel: self)
//    }
}
