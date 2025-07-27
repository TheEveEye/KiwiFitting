//
//  Item.swift
//  KiwiFitting
//
//  Created by Oskar on 7/27/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
