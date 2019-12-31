//
//  RoomRow.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 31/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct RoomRow: View {
    
    var image: String?
    var imageName: String
    var size: CGFloat
    var title: String?
    var type: String?
    
    var body: some View {
        HStack {
            ImageView(withURL: image, nameString: imageName, size: size)
            VStack {
                Text(title ?? "")
                Text(type ?? "")
            }
        }
    }
}
