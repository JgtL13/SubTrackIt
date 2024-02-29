//
//  DashboardView.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()
        
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
                                                //.frame(maxWidth: .infinity, alignment: .leading)
                                                .font(.title)
                                                .bold()
                                            Text("Expires: \(item.End_date)")
                                                //.frame(maxWidth: .infinity, alignment: .leading)
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
            .navigationTitle("Upcoming Renewals") // Add a title to the NavigationView
        }
    }
}

#Preview {
    DashboardView()
}
