//
//  ContentView.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }
            SubscriptionsView()
                .tabItem {
                    Image(systemName: "text.justify")
                    Text("Subscriptions")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .tint(colorScheme == .dark ? .white : .black)
    }
}

#Preview {
    ContentView()
}

