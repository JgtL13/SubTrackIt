//
//  AddItemViewModel.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import Foundation
import SwiftUI

class NewItemViewModel: ObservableObject {
    @Published var freeTrial = 0
    @Published var startDate = Date()
    @Published var selectedProvider: String?
    @Published var selectedPlan: Int?
    
    @Published var providerItems = [ProviderModel]()
    @Published var planItems = [PlanModel]()
    @Published var newItem = [NewItemModel]()
    //let prefixUrl = "http://127.0.0.1:8080"
    
    
    init() {
        fetchProviders()
        fetchPlans(provider: self.selectedProvider)
    }
    
    func fetchProviders() {
        guard let url = URL(string: "\(prefixUrl)/providers") else {
            print("Url not found")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, res, error) in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(ProviderDataModel.self, from: data)
                    DispatchQueue.main.async {
                        self.providerItems = result.data
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Decoding failed: \(error)")
            }
        }.resume()
    }
    
    func fetchPlans(provider: String?) {
        guard let provider = provider else {
            // Handle the case where provider is nil
            return
        }
        //var urlString = getPlansUrl
        //urlString += provider
        guard let url = URL(string: "\(prefixUrl)/plans/\(provider)") else {
            print("Url not found")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, res, error) in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(PlanDataModel.self, from: data)
                    DispatchQueue.main.async {
                        self.planItems = result.data
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Decoding failed: \(error)")
            }
        }.resume()
    }
    
    func addNewSubscription() {
        guard let url = URL(string: "\(prefixUrl)/newSubscription") else {
            print("Url not found")
            return
        }
        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the date format as needed
        
        // Format the startDate as a string
        let formattedStartDate = dateFormatter.string(from: self.startDate)
        
        // Construct the dictionary with non-optional attributes
        let newItem = NewItemModel(
            Start_date: formattedStartDate,
            Free_trial: self.freeTrial, // Assuming freeTrial is an Int
            User_ID: userID, // Assuming User_ID is a String
            Plan_ID: self.selectedPlan ?? 1 // Assuming selectedPlan is an optional Int
        )
        
        do {
            let jsonData = try JSONEncoder().encode(newItem)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON Data:", jsonString)
            } else {
                print("Failed to convert JSON data to string")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set content type
            
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            if let data = data {
                    // Print the data received from the network request
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response Data:", jsonString)
                    } else {
                        print("Failed to convert response data to string")
                    }
                } else {
                    print("No data received")
                }
            }.resume()
        } catch {
            print("Encoding error: \(error)")
        }
    }
}
