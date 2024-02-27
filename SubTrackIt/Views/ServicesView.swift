//
//  ServicesView.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import SwiftUI

struct ServicesView: View {
    @State private var searchText = ""
    @StateObject var viewModel = ServicesViewModel()
    
    var body: some View {
        List {
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
            //.navigationBarTitle("Subscription Services", displayMode: .large)
            //.navigationBarTitle("Subscription Services")
        }
        
        //ForEach(viewModel.items, id: \.self) { item in
                    
    }
}

#Preview {
    ServicesView()
}
