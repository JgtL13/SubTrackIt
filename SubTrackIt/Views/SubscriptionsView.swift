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
                                .frame(height: 160)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 5)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .overlay {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.Provider)
                                                .font(.title)
                                                .bold()
                                            Text(item.Plan_name)
                                                .font(.headline)
                                                .bold()
                                            Text("\(item.Subscription_type)\(item.Free_trial == 1 ? " (Free Trial)" : "")")
                                                .foregroundColor(.gray)
                                            Text("Effective: \(item.Start_date)")
                                                .foregroundColor(.gray)
                                            Text("Expires: \(item.End_date)")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.leading, 45)
                                        Spacer()
                                        VStack (alignment: .center) {
                                            Text(String(item.Remaining))
                                                .font(.title)
                                                .bold()
                                                .foregroundColor(item.Remaining <= 7 ? .red : .black)

                                            Text("days")
                                                .font(.caption) // Adjust the font size and style as needed
                                                .foregroundColor(.gray)
                                        }
                                        .frame(maxWidth: 120, alignment: .center)
                                        .padding(.trailing, 10)
                                        
                                    }
                                }
                        }
                    }
                }
            }
            .onAppear {viewModel.fetchSubscriptions(userID: viewModel.userID)}
            .refreshable {viewModel.fetchSubscriptions(userID: viewModel.userID)}
            .navigationTitle("Your Subscriptions") // Add a title to the NavigationView
            .toolbar {
                NavigationLink(destination: NewItemView()) {
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
