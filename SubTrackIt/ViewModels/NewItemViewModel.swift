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
    @Published var selectedPlan: String?
    
    @Published var providerItems = [ProviderModel]()
    @Published var planItems = [PlanModel]()
    let getProvidersUrl = "http://127.0.0.1:8080/providers"
    let getPlansUrl = "http://127.0.0.1:8080/plans/"
    
    
    init() {
        fetchProviders()
        fetchPlans(provider: selectedProvider)
    }
    
    func fetchProviders() {
            guard let url = URL(string: getProvidersUrl) else {
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
        var urlString = getPlansUrl
                
        // remember to correct this part, for development purposes only
        // urlString += "?deviceID=\(deviceID)"
        urlString += provider
        guard let url = URL(string: urlString) else {
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
}
