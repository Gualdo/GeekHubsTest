//
//  MainView.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 30/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct Dashboard: View {
    
    @ObservedObject var manager: NetworkHanlder
    
    @State var selected = 0
    
    var body: some View {
        TabView(selection: $selected) {
            User()
                .environmentObject(manager)
                .tabItem ({
                Image(systemName: "person.fill")
                    .font(.title)
                Text("User")
            }).tag(0)
            
            Rooms()
                .environmentObject(manager)
                .tabItem ({
                    Image(systemName: "message.fill")
                        .font(.title)
                    Text("Rooms")
                }).tag(1)
        }
        .accentColor(.red)
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(manager: NetworkHanlder())
    }
}
#endif
