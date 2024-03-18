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
            if (viewModel.username != "") {
                Text("Welcome!\n \(viewModel.username)")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .multilineTextAlignment(.center) // Aligning text in the middle
                    .toolbar {
                        Button(action: {
                            userID = ""
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
                    TextField("Name", text: $tempUsername)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                    
                    TextField("Email", text: $tempEmail)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $tempPassword)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                    
                    Button(action: {
                        viewModel.username = tempUsername
                        viewModel.email = tempEmail
                        viewModel.password = tempPassword
                        viewModel.syncData(method: "GET")
                        viewModel.syncData(method: "POST")
                        viewModel.syncData(method: "PUT")
                        
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
