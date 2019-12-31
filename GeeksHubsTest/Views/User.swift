//
//  User.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 31/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct User: View {
    
    @EnvironmentObject var manager: NetworkHanlder
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            ImageView(withURL: manager.userInfo?["avatar"] as? String ?? "")
            Text(manager.userInfo?["username"] as? String ?? "")
                .fontWeight(.bold)
                .font(.largeTitle)
            Text(manager.userInfo?["email"] as? String ?? "")
                .fontWeight(.bold)
                .font(.largeTitle)
        }
    }
}
