//
//  RoomsView.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 31/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct RoomsList: View {
    
    var roomsModel: RoomsModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(roomsModel.rooms ?? [Room]()) { room in
                    NavigationLink(destination: ChatView()) {
                        RoomRow(room: room, imageName: "Avatar", size: 30)
                    }
                }
            }
        }
    }
}
