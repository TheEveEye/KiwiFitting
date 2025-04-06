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
    var shipID: String
    
    var highSlots: [String]
    var midSlots: [String]
    var lowSlots: [String]
    
    var subsystems: Subsystem?
    
    init(id: UUID, name: String, shipID: String, highSlots: [String] = [], midSlots: [String] = [], lowSlots: [String] = [], subsystems: Subsystem? = nil) {
        self.id = id
        self.name = name
        self.shipID = shipID
        self.highSlots = highSlots
        self.midSlots = midSlots
        self.lowSlots = lowSlots
        self.subsystems = subsystems
    }
}

@Model
final class Subsystem {
    var propulsion: String?
    var defensive: String?
    var core: String?
    var offensive: String?
    
    init(propulsion: String? = nil, defensive: String? = nil, core: String? = nil, offensive: String? = nil) {
        self.propulsion = propulsion
        self.defensive = defensive
        self.core = core
        self.offensive = offensive
    }
}
