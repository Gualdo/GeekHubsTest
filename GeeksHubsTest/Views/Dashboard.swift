//
//  MainView.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 30/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct Dashboard: View {
    var body: some View {
        TabView {
            LoginView().tabItem {
                Image("Profile")
                    .font(.title)
                Text("User")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
