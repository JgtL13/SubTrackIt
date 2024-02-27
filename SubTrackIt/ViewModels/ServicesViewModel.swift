//
//  ServicesViewModel.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import Foundation

class ServicesViewModel: ObservableObject {
    @Published var items = [ProviderModel]()
    @Published var showingNewItemView = false
    let getProvidersUrl = "http://127.0.0.1:8080/providers"
    
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
                    let result = try JSONDecoder().decode(ProviderDataModel.self, from: data)
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


