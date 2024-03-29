//
//  AddItemView.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import SwiftUI

struct NewItemView: View {
    @ObservedObject var viewModel = NewItemViewModel()
    @Environment(\.presentationMode) var presentationMode
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
                //print("Selected option:", $viewModel.selectedProvider)
            }
            
            Picker("Plan", selection: $viewModel.selectedPlan) {
                Text("").tag(nil as Int?)
                ForEach(viewModel.planItems, id: \.Plan_ID) { item in
                    Text("\(item.Plan_name) - \(item.Duration_value) \(item.Duration_unit)")
                        .tag(item.Plan_ID as Int?)
                }
            }
            .pickerStyle(.navigationLink)
            /*
            .onChange(of: viewModel.selectedPlan) {
                print("Selected option:", $viewModel.selectedPlan)
            }
            */
            
            // Subscription start date
            DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
            
            // free trial (free trial price resumes after expiration)
            Toggle("Free Trial", isOn: Binding(
                get: {
                    viewModel.freeTrial == 1
                },
                set: { newValue in
                    viewModel.freeTrial = newValue ? 1 : 0
                }
            ))
        }
        .navigationTitle("New Subscription")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.addNewSubscription()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            //.padding()
            //.font(.system(size: 26))
        }
    }
}

#Preview {
    NewItemView()
}
