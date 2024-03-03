//
//  ProfileViewModel.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import Foundation
import SwiftUI
import CryptoKit

class ProfileViewModel: ObservableObject {
    @Published var username: String
    @Published var email: String
    @Published var password: String
    @Published var items = [UsernameModel]()
    //@Published var email: String
    //@Published var password: String
    
    init() {
        username = ""
        email = ""
        password = ""
        getUsername()
    }
    
    // if the User_ID is found, and User_ID is found in table Account, display "Welcome! (user_name)!"
    // if the User_ID is found, but not the email, display a registration page
    // registration page will allow users to enter their email, password, and user_name (does not have to be unique, just a name)
    // if the User_ID is not found, display the "sync data" page
    // and allow users to input email and password
    // and fetch the User_ID using the email and password.
    
    func hashPassword(_ password: String) -> String {
        if let data = password.data(using: .utf8) {
            let hashedData = SHA256.hash(data: data)
            let hashedString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
            return hashedString
        } else {
            // Handle error if unable to convert password to data
            return ""
        }
    }
    
    func getUsername () {
        guard let url = URL(string: "\(prefixUrl)/getUsername") else {
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
                    let result = try JSONDecoder().decode(UsernameDataModel.self, from: data)
                    DispatchQueue.main.async {
                        if let username = result.data.first?.User_name {
                            self.username = username
                        } else {
                            print("No username found in the response")
                        }
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Decoding failed: \(error)")
            }
        }.resume()
    }
    
    // has account, but device identifier is wrong
    func syncData (method: String) {
        guard let url = URL(string: "\(prefixUrl)/syncData") else {
            print("Url not found")
            return
        }
        var request = URLRequest(url: url)
        
        if(method == "GET") {
            request.httpMethod = method
            request.addValue(self.email, forHTTPHeaderField: "email") // Set device ID as custom HTTP header
            request.addValue(hashPassword(self.password), forHTTPHeaderField: "password") // Set device ID as custom HTTP header
            //request.addValue(self.password, forHTTPHeaderField: "password") // Set device ID as custom HTTP header
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                if error != nil {
                    print("error", error?.localizedDescription ?? "")
                    return
                }
                
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode(SyncDataDataModel.self, from: data)
                        DispatchQueue.main.async {
                            if let user_ID = result.data.first?.User_ID {
                                userID = user_ID
                            } else {
                                print("No username found in the response")
                            }
                        }
                    } else {
                        print("No data")
                    }
                } catch {
                    print("Decoding failed: \(error)")
                }
            }.resume()
        }
        else if(method == "POST") {
            request.httpMethod = method
            request.addValue(self.email, forHTTPHeaderField: "email") // Set device ID as custom HTTP header
            request.addValue(hashPassword(self.password), forHTTPHeaderField: "password") // Set device ID as custom HTTP header
            request.addValue(userID, forHTTPHeaderField: "User-ID") // Set device ID as custom HTTP header
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                if error != nil {
                    print("error", error?.localizedDescription ?? "")
                    return
                }
                
                guard let httpResponse = res as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }

                if httpResponse.statusCode == 200 {
                    print("Subscription deleted successfully")
                    // Perform any additional actions after successful deletion
                } else {
                    print("Failed to delete subscription. Status code:", httpResponse.statusCode)
                    // Handle the failure scenario accordingly
                }
            }.resume()
        }
        else if(method == "PUT") {
            request.httpMethod = method
            request.addValue(self.username, forHTTPHeaderField: "username") // Set device ID as custom HTTP header
            request.addValue(userID, forHTTPHeaderField: "User-ID") // Set device ID as custom HTTP header
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                if error != nil {
                    print("error", error?.localizedDescription ?? "")
                    return
                }
                
                guard let httpResponse = res as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }

                if httpResponse.statusCode == 200 {
                    print("Subscription deleted successfully")
                    // Perform any additional actions after successful deletion
                } else {
                    print("Failed to delete subscription. Status code:", httpResponse.statusCode)
                    // Handle the failure scenario accordingly
                }
            }.resume()
        }
        
    }
}
