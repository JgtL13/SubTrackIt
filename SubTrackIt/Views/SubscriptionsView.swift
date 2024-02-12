//
//  SubscriptionsView.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import SwiftUI

struct SubscriptionsView: View {
    var body: some View {
        NavigationView {
            VStack {
                
            }
            // .navigationTitle("Today")
            .toolbar {
                Button {
                    // Action
                } label: {
                    Image(systemName: "plus")
                }
                .padding()
                .font(.system(size: 26))
            }
        }
    }
}

#Preview {
    SubscriptionsView()
}
