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
                                            .lineLimit(1) // Prevent text from wrapping to the next line
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
                                    .frame(maxWidth: 60, alignment: .center)
                                    .padding(.trailing, 40)
                                    
                                }
                            }
                            .contextMenu {
                                Button(action: {
                                    viewModel.renewSubscription(subscriptionID: item.Subscription_ID)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        viewModel.fetchSubscriptions(userID: userID)
                                    }
                                }) {
                                    Text("Renew")
                                    Image(systemName: "arrow.clockwise")
                                }
                                Button(action: {
                                    // Handle delete action
                                    viewModel.deleteSubscription(subscriptionID: item.Subscription_ID)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        viewModel.fetchSubscriptions(userID: userID)
                                    }
                                }) {
                                    Text("Unsubscribe")
                                    Image(systemName: "trash")
                                }
                            }
                    }
                }
            }
            .onAppear {viewModel.fetchSubscriptions(userID: userID)}
            .refreshable {viewModel.fetchSubscriptions(userID: userID)}
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
