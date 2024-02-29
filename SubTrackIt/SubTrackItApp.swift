//
//  SubTrackItApp.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import SwiftUI

@main
struct SubTrackItApp: App {
    init() {
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(DashboardViewModel())
        }
    }
}
