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
        print(viewModel.items)
        
    }
    
    var body: some View {
        NavigationView {
            List {
                //ForEach(viewModel.items, id: \.self) { item in
                ForEach(viewModel.items, id: \.self) { item in
                    NavigationLink(
                        destination: ItemView(),
                        label: {
                            VStack(alignment: .leading) {
                                Text(item.Provider)
                                //Text(item.post).font(.caption).foregroundColor(.gray)
                            }
                        })
                }
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
