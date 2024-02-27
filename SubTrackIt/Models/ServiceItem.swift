//
//  SubscriptionItem.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import Foundation
import SwiftUI

struct ProviderDataModel: Decodable, Hashable {
    let error: Bool
    let message: String?
    let data: [ProviderModel]
}

struct ProviderModel: Decodable, Hashable {
    let Provider: String
}

struct SubscriptionDataModel: Decodable, Hashable {
    let error: Bool
    let message: String?
    let data: [SubscriptionModel]
}

struct SubscriptionModel: Decodable, Hashable {
    let Provider: String
    let Plan_name: String
    let End_date: String
    let Remaining: Int
}
