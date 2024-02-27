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
    @Published var showingNewItemView = false
    let getSubscriptionsUrl = "http://127.0.0.1:8080/subscriptions/"
    
    init() {
        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else {
            print("Unable to retrieve device identifier")
            return
        }
        fetchSubscriptions(deviceID: deviceID)
    }
    
    func daysUntilDate(dateString: String) -> Int? {
        // Create a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Assuming the date format is "yyyy-MM-dd"

        // Parse the string date into a Date object
        guard let targetDate = dateFormatter.date(from: dateString) else {
            return nil // Return nil if unable to parse the date
        }

        // Get the current calendar and current date
        let calendar = Calendar.current
        let currentDate = Date()

        // Calculate the difference in days between the target date and the current date
        let components = calendar.dateComponents([.day], from: currentDate, to: targetDate)
        guard let days = components.day else {
            return nil // Return nil if unable to calculate the difference
        }

        return days
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
