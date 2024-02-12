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
            ForEach(viewModel.serviceList, id: \.self) { service in
                NavigationLink(destination: Text(service)) {
                    Image(systemName: "play.rectangle.fill")
                    Text(service)
                }
                .padding()
            }
            //.navigationBarTitle("Subscription Services", displayMode: .large)
            //.navigationBarTitle("Subscription Services")
        }
    }
}

#Preview {
    ServicesView()
}
