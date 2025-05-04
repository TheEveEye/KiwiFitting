//
//  Module.swift
//  KiwiFitting
//
//  Created by Oskar on 16.04.25.
//

import Foundation
import SwiftData
import SwiftUI

public protocol Module {
    var typeID: String { get }
    var state: ModuleState { get set }
    var charge: ModuleCharge? { get set }
    var possibleStates: [ModuleState] { get }
}

public func inferModule(typeID: String, slotType: SlotType? = nil) -> (any Module)? {
    return HighModule(typeID: "3082", type: .turret)
//    guard let slotType = inferSlotType(for: typeID) else {
//        return nil
//    }
//    
//    let possibleModuleTypes = inferPossibleStates(for: typeID)
//    
//    switch slotType {
//    case .high: return HighModule(typeID: typeID, type: inferHighSlotType(for: typeID))
//    case .mid:
//        return MidModule(typeID: typeID)
//    case .low:
//        return LowModule(typeID: typeID)
//    case .rig:
//        return RigModule(typeID: typeID)
//    case .coreSubsystem, .defensiveSubsystem, .propulsionSubsystem, .offensiveSubsystem:
//        return SubsystemModule(typeID: typeID)
//    }
    
}

func inferSlotType(for typeID: String) -> SlotType? {
    var dataManager = DataManager()
    
    guard let effects = dataManager.TypesDogma[typeID]?.dogmaEffects else {
        return nil
    }
    
    if effects.contains(where: { effect in
        effect.effectID == 12 // hiPower
    }) {
        return .high
    } else if effects.contains(where: { effect in
        effect.effectID == 13 // medPower
    }) {
        return .mid
    } else if effects.contains(where: { effect in
        effect.effectID == 11 // loPower
    }) {
        return .low
    } else if effects.contains(where: { effect in
        effect.effectID == 2663 // rigSlot
    }) {
        return .rig
    } else if effects.contains(where: { effect in
        effect.effectID == 3772 // subSystem
    }) {
        return .coreSubsystem // FIXME: add differentiation between subsystem slots
    } else {
        return nil
    }
}

/// Alternative way to figure out the possible state (may be more reliable & future proof) is to check through all module dogma effects and see if at least one of the effect categories is "online" (4) and then if one is "overload" (5). Sort with enum
func inferPossibleStates(for typeID: String) -> [ModuleState] {
    var possibleStates: [ModuleState] = [.offline, .online] // Every module can be in these states
    var dataManager = DataManager()
    let attributes = dataManager.TypesDogma[typeID]?.dogmaAttributes ?? []
    
    // TODO: Figure out how to identify modules that can be activated but not overloaded
    
    // If it has a activation time or duration, it can be activated
    if attributes.contains(where: { $0.attributeID == 37 || $0.attributeID == 51 }) {
        possibleStates.append(.active)
    }
    
    // If it has a reactivation delay, it can be activated
    if attributes.contains(where: { $0.attributeID == 669 }) {
        possibleStates.append(.active)
    }
    
    // If it requires Thermodynamics skill, it can be overloaded
    if attributes.contains(where: { $0.attributeID == 1212 }) {
        if !possibleStates.contains(.active) {
            possibleStates.append(.active)
        }
        possibleStates.append(.overload)
    }
    
    return possibleStates
}

func inferHighSlotType(for typeID: String) -> HighSlotType {
    var dataManager = DataManager()
    let effects = dataManager.TypesDogma[typeID]?.dogmaEffects ?? []
    
    if effects.contains(where: { $0.effectID == 42 }) {
        return .turret
    } else if effects.contains(where: { $0.effectID == 40 }) {
        return .launcher
    } else {
        return .utility
    }
}

public enum SlotType {
    case high
    case mid
    case low
    case rig
    case defensiveSubsystem
    case offensiveSubsystem
    case propulsionSubsystem
    case coreSubsystem
}

public enum ModuleState {
    case online
    case offline
    case overload
    case active
}

extension SlotType {
    var image: Image {
        switch self {
        case .high:
            return Image("highSlot")
        case .mid:
            return Image("midSlot")
        case .low:
            return Image("lowSlot")
        case .rig:
            return Image("rigSlot")
        case .defensiveSubsystem:
            return Image("defensiveSubsystem")
        case .offensiveSubsystem:
            return Image("offensiveSubsystem")
        case .propulsionSubsystem:
            return Image("propulsionSubsystem")
        case .coreSubsystem:
            return Image("coreSubsystem")
        }
    }
}

public struct ModuleCharge {
    var typeID: String
    var amount: Int
}

public extension ModuleCharge {
    static var empty: ModuleCharge {
        .init(typeID: "", amount: 0)
    }
}

public class HighModule: Module {
    public var typeID: String
    public var state: ModuleState
    var type: HighSlotType
    public var charge: ModuleCharge?
    public var possibleStates: [ModuleState]
    
    init(typeID: String, state: ModuleState = .online, type: HighSlotType, charge: ModuleCharge? = nil) {
        self.typeID = typeID
        self.state = state
        self.type = type
        self.charge = charge
        self.possibleStates = inferPossibleStates(for: typeID)
    }
}

public enum HighSlotType {
    case turret
    case launcher
    case utility
}

public class MidModule: Module {
    public var typeID: String
    public var state: ModuleState
    public var charge: ModuleCharge?
    public var possibleStates: [ModuleState]
    
    init(typeID: String, state: ModuleState = .online, charge: ModuleCharge? = nil) {
        self.typeID = typeID
        self.state = state
        self.charge = charge
        self.possibleStates = inferPossibleStates(for: typeID)
    }
}

public class LowModule: Module {
    public var typeID: String
    public var state: ModuleState
    public var charge: ModuleCharge?
    public var possibleStates: [ModuleState]
    
    init(typeID: String, state: ModuleState = .online, charge: ModuleCharge? = nil) {
        self.typeID = typeID
        self.state = state
        self.charge = charge
        self.possibleStates = inferPossibleStates(for: typeID)
    }
}

public class RigModule: Module {
    public var typeID: String
    public var state: ModuleState
    public var possibleStates: [ModuleState] = [.offline, .online]
    public var charge: ModuleCharge? = nil // Rigs can't have charges loaded, they're rigs...
    
    init(typeID: String, state: ModuleState = .online) {
        self.typeID = typeID
        self.state = state
    }
}

public class SubsystemModule: Module {
    public var typeID: String
    public var state: ModuleState
    public var possibleStates: [ModuleState] = [.offline, .online]
    public var charge: ModuleCharge? = nil // Rigs can't have charges loaded, they're rigs...
    
    init(typeID: String, state: ModuleState = .online) {
        self.typeID = typeID
        self.state = state
    }
}
