//
//  Rooms.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 31/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct Rooms: View {
    
    @EnvironmentObject var manager: NetworkHanlder
    
    var body: some View {
        Text("This is ROOMS")
    }
}

struct Rooms_Previews: PreviewProvider {
    static var previews: some View {
        Rooms()
    }
}
