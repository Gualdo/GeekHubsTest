//
//  RoomRow.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 31/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct RoomRow: View {
    
    var room: Room
    var imageName: String
    var size: CGFloat
    
    var body: some View {        
        HStack {
            ImageView(withURL: room.image, nameString: imageName, size: size)
            VStack {
                Text(room.title ?? "")
                Text(room.roomType ?? "")
            }
        }
    }
}
