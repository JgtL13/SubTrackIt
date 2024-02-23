//
//  SubscriptionItem.swift
//  SubTrackIt
//
//  Created by Justin Lin on 2/11/24.
//

import Foundation
import SwiftUI

struct DataModel: Decodable, Hashable {
    let error: Bool
    let message: String?
    let data: [ProviderModel]
}

struct ProviderModel: Decodable, Hashable {
    let Provider: String
}
