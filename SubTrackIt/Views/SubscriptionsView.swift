//
//  SubscriptionsView.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import SwiftUI

struct SubscriptionsView: View {
    @StateObject var viewModel = SubscriptionsViewModel()
    
    init() {
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
            }
            // .navigationTitle("Today")
            .toolbar {
                NavigationLink(destination: ServicesView()) {
                    Image(systemName: "plus")
                }
                .padding()
                .font(.system(size: 26))
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView()
            }
        }
    }
}

#Preview {
    SubscriptionsView()
}
