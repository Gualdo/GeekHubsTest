//
//  UsersModel.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 03/01/2020.
//  Copyright © 2020 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct User: Decodable {
    var `id`: String?
    var username: String?
    var avatar: String?
    var email: String?
    var notificationsEnabled: Bool?
    var emergencyModeEnabled: Bool?
    var isBlocked: Bool?
    var isValidatedAccount: Bool?
    var counterRooms: Int?
    var counterCalls: Int?
    var counterContacts: Int?
}

class UsersModel  {
    
    @ObservedObject var manager: NetworkHanlder
    
    var user: User?
    
    var view: UserView?
    
    init(manager: NetworkHanlder) {
        self.manager = manager
        guard let data = manager.userInfo else { return }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.user = try decoder.decode(User.self, from: data)
        } catch let jsonError {
            print("Failed to decode:", jsonError)
        }
        
        self.configureView()
    }
    
    fileprivate func configureView() {
        self.view = UserView(userModel: self)
    }
}
