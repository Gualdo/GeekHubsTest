//
//  RoomsModel.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 03/01/2020.
//  Copyright © 2020 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct Room: Decodable {
    var `id`: String?
    var image: String?
    var title: String?
    var roomType: String?
    var numUsers: Int?
    var newMessages: Int?
    var lastMessageUsername: String?
    var lastMessageDate: String?
    var isMuted: Bool?
}

class RoomsModel  {
    
    @ObservedObject var manager: NetworkHanlder
    
    var rooms: [Room]?
    
    var view: RoomsView?
    
    init(manager: NetworkHanlder) {
        self.manager = manager
        guard let data = manager.userInfo else { return }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.rooms = try decoder.decode([Room].self, from: data)
        } catch let jsonError {
            print("Failed to decode:", jsonError)
        }
        
        self.configureView()
    }
    
    fileprivate func configureView() {
        self.view = RoomsView(roomsModel: self)
    }
}
