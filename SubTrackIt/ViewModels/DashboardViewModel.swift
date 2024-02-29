//
//  DashboardViewModel.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var items = [SubscriptionModel]()
    let getSubscriptionsUrl = "http://127.0.0.1:8080/dashboard/"
    
    init() {
        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else {
            print("Unable to retrieve device identifier")
            return
        }
        fetchSubscriptions(deviceID: deviceID)
    }
    
    func fetchSubscriptions(deviceID: String) {
        var urlString = getSubscriptionsUrl
        
        // remember to correct this part, for development purposes only
        // urlString += "?deviceID=\(deviceID)"
        urlString += "1"
        
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
                    let result = try JSONDecoder().decode(SubscriptionDataModel.self, from: data)
                    DispatchQueue.main.async {
                        self.items = result.data
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
