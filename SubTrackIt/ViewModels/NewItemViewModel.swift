//
//  AddItemViewModel.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import Foundation
import SwiftUI

class NewItemViewModel: ObservableObject {
    @Published var title = ""
    @Published var freeTrial = false
    @Published var startDate = Date()
    @Published var selectedProvider: String?
    @Published var selectedPlan: Int?
    
    @Published var providerItems = [ProviderModel]()
    @Published var planItems = [PlanModel]()
    @Published var newItem = [NewItemModel]()
    let prefixUrl = "http://127.0.0.1:8080"
    //let getProvidersUrl = "http://127.0.0.1:8080/providers"
    //let getPlansUrl = "http://127.0.0.1:8080/plans/"
    //let newSubscriptionUrl = "http://127.0.0.1:8080/newSubscription"
    
    
    init() {
        fetchProviders()
        fetchPlans(provider: selectedProvider)
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
    
    func AddNewSubscription() {
        guard let url = URL(string: "\(prefixUrl)/newSubscription") else {
            print("Url not found")
            return
        }
        //let data = try! JSONSerialization.data(withJSONObject: parameters)
        // newItem.Start_date =
        // newItem.Free_trial =
        // newItem.User_ID =
        // newItem.Plan_ID = selectedPlan
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // Set content type
        //request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(NewItemDataModel.self, from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Decoding failed: \(error)")
            }
        }.resume()
    }
}
