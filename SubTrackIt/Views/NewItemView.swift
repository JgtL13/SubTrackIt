//
//  AddItemView.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewModel()
    //@State private var selectedProvider: String?
    //@State private var selectedPlan: String?
    
    var body: some View {
        Form {
            // Service, get from clicked value
            Picker("Provider", selection: $viewModel.selectedProvider) {
                Text("").tag(nil as String?)
                ForEach(viewModel.providerItems, id: \.self) { item in
                    Text(item.Provider)
                        .tag(item.Provider as String?)
                }
            }
            .pickerStyle(.navigationLink)
            .onChange(of: viewModel.selectedProvider) {
                viewModel.fetchPlans(provider: viewModel.selectedProvider)
            }

            
            Picker("Plan", selection: $viewModel.selectedPlan) {
                Text("").tag(nil as String?)
                ForEach(viewModel.planItems, id: \.self) { item in
                    Text(item.Plan_name)
                        .tag(item.Plan_name as String?)
                }
            }
            .pickerStyle(.navigationLink)
            
            // Subscription type (free trial price resumes after expiration)
            
            // Subscription start date
            DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
            
            // free trial (free trial price resumes after expiration)
            Toggle("Free Trial", isOn: $viewModel.freeTrial)
            
            // Choose Subscription length
            
            // Button
        }
    }
}

#Preview {
    NewItemView()
}
