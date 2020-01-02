//
//  Login.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 02/01/2020.
//  Copyright © 2020 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI
import Combine

struct InputTextField: View {
    
    @Binding var stateBinding: String
    
    let label: String
    let placeholder: String
    let secureTextfield: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .foregroundColor(.white)
            
            if secureTextfield {
                SecureField(placeholder, text: $stateBinding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                TextField(placeholder, text: $stateBinding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}

struct Login: View {
    
    @ObservedObject var manager: NetworkHanlder
    
    @State var username: String = ""
    @State var password: String = ""
    
    var isDisabled: Bool {
        return username == "" || password == ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            HStack {
                Spacer()
                Image("Logo")
                    .cornerRadius(10)
                Spacer()
            }
            Spacer()
            InputTextField(stateBinding: $username, label: "Username", placeholder: "Username", secureTextfield: false)
            InputTextField(stateBinding: $password, label: "Password", placeholder: "Password", secureTextfield: true)
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    var JSONDictionary = [String: AnyObject]()
                    JSONDictionary["cmd"] = "LOGIN" as AnyObject
                    JSONDictionary["email"] = self.username as AnyObject
                    JSONDictionary["password"] = self.password as AnyObject
                    self.manager.doLogin(JSONDictionary)
                }) {
                    HStack {
                        Spacer()
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(isDisabled ? .black : .red)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(isDisabled ? Color.gray : Color.white)
                    .cornerRadius(5)
                }
                .opacity(isDisabled ? 0.5 : 1)
                .disabled(isDisabled)
                .alert(isPresented: $manager.gotError) { Alert(title: Text("Something went wrong"), message: Text("We have got an error lets try againg"), dismissButton: .default(Text("Got it!")))
                }
                Spacer()
            }.padding(.horizontal, 72)
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Image("Background")
            .resizable()
            .scaledToFill()
            .clipped())
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(manager: NetworkHanlder())
    }
}
