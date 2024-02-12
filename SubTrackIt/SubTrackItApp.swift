//
//  SubTrackItApp.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import FirebaseCore
import SwiftUI

@main
struct SubTrackItApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
