//
//  UserView.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 31/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct UserView: View {
    
    var userModel: UsersModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            ImageView(withURL: userModel.user?.avatar ?? "", nameString: "avatar", size: 150)
            Text(userModel.user?.username ?? "")
                .fontWeight(.bold)
                .font(.largeTitle)
            Text(userModel.user?.email ?? "")
                .fontWeight(.bold)
                .font(.largeTitle)
        }
    }
}
