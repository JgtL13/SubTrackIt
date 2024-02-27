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
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.items, id: \.self) { item in
                        NavigationLink(destination: ItemView()) {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .frame(height: 100)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 5)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .overlay {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.Provider)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .font(.title)
                                                .bold()
                                            Text("Expires: \(item.End_date)")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.horizontal, 50)
                                        Spacer()
                                        Text(String(item.Remaining))
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(item.Remaining <= 7 ? .red : .black)
                                            .padding(.trailing, 50)
                                    }
                                }
                        }
                    }
                }
            }
            .toolbar {
                NavigationLink(destination: ServicesView()) {
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
