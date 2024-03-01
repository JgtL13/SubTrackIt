//
//  ProfileView.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("My Account")) {
                    
                }
            }
            .navigationTitle("Account")
        }
    }
}

#Preview {
    ProfileView()
}
