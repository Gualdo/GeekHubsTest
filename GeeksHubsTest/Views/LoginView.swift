//
//  ContentView.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 30/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI

struct LoginView: View, ResponseHandler {
    
    @EnvironmentObject var manager: NetworkHanlder
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    
    var isDisabled: Bool {
        return email == "" || password == ""
    }
    
    var buttonColor: Color {
        return isDisabled ? .gray : .black
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Image("image002")
            Spacer()
            TextField("Username", text: $email)
                .padding(.horizontal, 10.0)
                .frame(height: 50.0)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            TextField("Password", text: $password)
                .padding(.horizontal, 10.0)
                .frame(height: 50.0)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            Spacer()
            Button(action: {
                self.manager.delegate = self
                var JSONDictionary = [String: AnyObject]()
                JSONDictionary["cmd"] = "LOGIN" as AnyObject
                JSONDictionary["email"] = self.email as AnyObject
                JSONDictionary["password"] = self.password as AnyObject
                self.manager.doLogin(JSONDictionary)
            }) {
                Text("Login")
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(buttonColor)
                    .multilineTextAlignment(.center)
                    .padding(.all, 7.0)
                    .frame(width: 200.0)
                    .border(Color.red, width: 5)
            }
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.2 : 1)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Something went wrong"), message: Text("We have got an error lets try againg"), dismissButton: .default(Text("Got it!")))
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 8, leading: 50, bottom: 8, trailing: 50))
    }
    
    func errorReceived() {
        showingAlert = true
    }
}
