//
//  ProfileView.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State var tempUsername: String = ""
    @State var tempEmail: String = ""
    @State var tempPassword: String = ""
    
    var body: some View {
        NavigationView {
            if (viewModel.email != "") {
                Text("Welcome!\n \(viewModel.username != "" ? viewModel.username : viewModel.email)")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .multilineTextAlignment(.center) // Aligning text in the middle
                    .toolbar {
                        Button(action: {
                            resetUserID()
                            print(userID)
                            viewModel.username = ""
                            viewModel.email = ""
                            viewModel.password = ""
                        }) {
                            Text("Logout")
                                .padding()
                                .font(.system(size: 26))
                        }
                    }
            } else {
                // username not found -> create account and sync data
                // login and sync data
                // login page...

                Form {
                    TextField("Name (optional)", text: $tempUsername)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                    
                    TextField("Email", text: $tempEmail)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $tempPassword)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                    
                    Button(action: {
                        // using email and password
                        // try to get username using UserID.
                        // If username doesnt exist, use email instead.
                        viewModel.email = tempEmail
                        viewModel.password = tempPassword
                        viewModel.syncData(method: "GET")
                        viewModel.syncData(method: "POST")
                        if (tempUsername != "") {
                            viewModel.username = tempUsername
                            viewModel.syncData(method: "PUT")
                        }
                        
                        
                    }) {
                        Text("Sync Data")
                            .foregroundColor(.white)
                            
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                    )
                }
                .navigationBarTitle("Account")
            }
        }
    }
}

#Preview {
    ProfileView()
}
