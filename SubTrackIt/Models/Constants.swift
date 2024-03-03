//
//  Constants.swift
//  SubTrackIt
//
//  Created by Justin Lin on 3/2/24.
//

import Foundation
import SwiftUI

let prefixUrl = "http://127.0.0.1:8080"
//var userID = "1"
//var userID = "4B797EC4-8720-4F21-A685-3F62D4B30099"

var userID: String = {
    if let identifier = UIDevice.current.identifierForVendor?.uuidString {
        createUser(userID: identifier)
        return identifier
    } else {
        // If unable to retrieve the identifier, set a default value or handle the error
        print("Unable to retrieve device identifier, creating a new one")
        return "" // Set a default value or handle the error accordingly
    }
}()

func createUser(userID: String) {
    guard let url = URL(string: "\(prefixUrl)/createUser") else {
        print("Url not found")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
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
            print("User created successfully")
            // Perform any additional actions after successful deletion
        } else {
            print("User already exists. Status code:", httpResponse.statusCode)
            // Handle the failure scenario accordingly
        }
    }.resume()
}


