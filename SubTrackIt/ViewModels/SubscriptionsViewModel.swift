//
//  SubscriptionsViewModel.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import Foundation
import SwiftUI

class SubscriptionsViewModel: ObservableObject {
    @Published var items = [ProviderModel]()
    @Published var showingNewItemView = false
    let getProvidersUrl = "http://127.0.0.1/SubTrackIt/v1/index.php"
    
    init() {
        fetchProviders()
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
                    print("1")
                    let result = try JSONDecoder().decode(DataModel.self, from: data)
                    print(result)
                    print("2")
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
