//
//  AddItemView.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewModel()

    
    var body: some View {
        VStack {
            Form {
                // Service
                
                // Subscription start date
                DatePicker("Start Date", selection: $viewModel.startDate)
                    .datePickerStyle(CompactDatePickerStyle())
                
                // Choose Subscription lenght
                
                // Button
            }
        }
    }
}

#Preview {
    NewItemView()
}
