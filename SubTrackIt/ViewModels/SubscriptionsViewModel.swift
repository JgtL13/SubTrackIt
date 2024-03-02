//
//  SubscriptionsViewModel.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import Foundation
import SwiftUI

class SubscriptionsViewModel: ObservableObject {
    @Published var items = [SubscriptionModel]()
    @Published var userID = "1"
    
    let prefixUrl = "http://127.0.0.1:8080"
    
    init() {
        //guard let userID = UIDevice.current.identifierForVendor?.uuidString else {
        //    print("Unable to retrieve device identifier")
        //    return
        //}
        // remember to edit this part, for testing purposes
        let userID = "1"
        fetchSubscriptions(userID: userID)
    }
    
    func fetchSubscriptions(userID: String) {
        guard let url = URL(string: "\(prefixUrl)/subscriptions") else {
            print("Url not found")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(userID, forHTTPHeaderField: "User-ID") // Set device ID as custom HTTP header
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
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
    
    func deleteSubscription(subscriptionID: Int) {
        guard let url = URL(string: "\(prefixUrl)/deleteSubscription") else {
            print("Url not found")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(String(subscriptionID), forHTTPHeaderField: "Subscription-ID") // Set device ID as custom HTTP header
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            guard let httpResponse = res as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            if httpResponse.statusCode == 204 {
                print("Subscription deleted successfully")
                // Perform any additional actions after successful deletion
            } else {
                print("Failed to delete subscription. Status code:", httpResponse.statusCode)
                // Handle the failure scenario accordingly
            }
        }.resume()
    }
    
    func renewSubscription(subscriptionID: Int) {
        guard let url = URL(string: "\(prefixUrl)/renewSubscription") else {
            print("Url not found")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue(String(subscriptionID), forHTTPHeaderField: "Subscription-ID") // Set device ID as custom HTTP header
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if error != nil {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            guard let httpResponse = res as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            if httpResponse.statusCode == 204 {
                print("Subscription deleted successfully")
                // Perform any additional actions after successful deletion
            } else {
                print("Failed to delete subscription. Status code:", httpResponse.statusCode)
                // Handle the failure scenario accordingly
            }
        }.resume()
    }
    

}
