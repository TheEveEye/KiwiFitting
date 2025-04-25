//
//  StackableItem.swift
//  KiwiFitting
//
//  Created by Oskar on 14.04.25.
//

import Foundation
import SwiftData

@Model
class InvItem {
    var typeID: String
    var amount: Int
    var stackable: Bool
    
    init(_ typeID: String, amount: Int = 1, stackable: Bool = false) {
        self.typeID = typeID
        self.stackable = amount > 1 || stackable
        self.amount = amount
        
    }
}
