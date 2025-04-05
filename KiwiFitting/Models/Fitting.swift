//
//  Fitting.swift
//  KiwiFitting
//
//  Created by Oskar on 4/3/25.
//

import Foundation
import SwiftData

@Model
final class Fitting: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var shipId: Int
    
    var highSlots: [Int]
    var midSlots: [Int]
    var lowSlots: [Int]
    
    var subsystems: Subsystem?
    
    init(id: UUID, name: String, shipId: Int, highSlots: [Int] = [], midSlots: [Int] = [], lowSlots: [Int] = [], subsystems: Subsystem? = nil) {
        self.id = id
        self.name = name
        self.shipId = shipId
        self.highSlots = highSlots
        self.midSlots = midSlots
        self.lowSlots = lowSlots
        self.subsystems = subsystems
    }
}

@Model
final class Subsystem {
    var propulsion: Int?
    var defensive: Int?
    var core: Int?
    var offensive: Int?
    
    init(propulsion: Int? = nil, defensive: Int? = nil, core: Int? = nil, offensive: Int? = nil) {
        self.propulsion = propulsion
        self.defensive = defensive
        self.core = core
        self.offensive = offensive
    }
}
