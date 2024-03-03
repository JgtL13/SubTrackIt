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

struct UsernameDataModel: Decodable, Hashable {
    let error: Bool
    let message: String?
    let data: [UsernameModel]
}

struct UsernameModel: Decodable, Hashable {
    let User_name: String
}

struct SyncDataDataModel: Decodable, Hashable {
    let error: Bool
    let message: String?
    let data: [SyncDataModel]
}

struct SyncDataModel: Decodable, Hashable {
    let User_ID: String
}

struct PlanDataModel: Decodable, Hashable {
    let error: Bool
    let message: String?
    let data: [PlanModel]
}

struct PlanModel: Decodable, Hashable {
    let Plan_ID: Int
    let Plan_name: String
    let Duration_value: Int
    let Duration_unit: String
}

struct SubscriptionDataModel: Decodable, Hashable {
    let error: Bool
    let message: String?
    let data: [SubscriptionModel]
}

struct SubscriptionModel: Decodable, Hashable {
    let Provider: String
    let Plan_name: String
    let Subscription_type: String
    let Subscription_ID: Int
    let Free_trial: Int
    let Start_date: String
    let End_date: String
    let Remaining: Int
}

struct NewItemDataModel: Encodable, Decodable, Hashable {
    let error: Bool
    let message: String?
    let data: [NewItemModel]
}

struct NewItemModel: Encodable, Decodable, Hashable {
    let Start_date: String
    let Free_trial: Int
    let User_ID: String
    let Plan_ID: Int
}
