//
//  Root.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 31/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct Root: View {
    
    @EnvironmentObject var manager: NetworkHanlder
    
    var body: some View {
        VStack {
            if manager.isInfoCopleted {
                Dashboard().environmentObject(manager)
            } else {
                LoginView()
            }
        }
    }
}

#if DEBUG
struct Root_Previews: PreviewProvider {
    static var previews: some View {
        Root()
    }
}
#endif
