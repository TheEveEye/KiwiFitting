////
////  Module.swift
////  KiwiFitting
////
////  Created by Oskar on 16.04.25.
////
//
//import Foundation
//import SwiftData
//
//public protocol Module {
//    var typeID: String { get }
//    var state: ModuleState { get set }
//    var charge: ModuleCharge? { get set }
//    var possibleStates: [ModuleState] { get }
//}
//
//public enum ModuleState {
//    case online
//    case offline
//    case overload
//    case active
//}
//
//public struct ModuleCharge {
//    var typeID: String
//    var amount: Int
//}
//
//extension ModuleCharge {
//    public static var empty: ModuleCharge {
//        .init(typeID: "", amount: 0)
//    }
//}
//
//public class HighModule: Module {
//    public var typeID: String
//    public var state: ModuleState
//    var type: HighSlotType
//    public var charge: ModuleCharge?
//    public var possibleStates: [ModuleState]
//    
//    init(typeID: String, state: ModuleState = .online, type: HighSlotType, charge: ModuleCharge? = nil) {
//        self.typeID = typeID
//        self.state = state
//        self.type = type
//        self.charge = charge
//        // TODO: Write function to figure out possible states
//    }
//}
//
//public enum HighSlotType {
//    case turret
//    case launcher
//    case utility
//}
//
//public class MidModule: Module {
//    public var typeID: String
//    public var state: ModuleState
//    public var charge: ModuleCharge?
//    public var possibleStates: [ModuleState]
//    
//    init(typeID: String, state: ModuleState = .online, charge: ModuleCharge? = nil) {
//        self.typeID = typeID
//        self.state = state
//        self.charge = charge
//    }
//}
//
//public class LowModule: Module {
//    public var typeID: String
//    public var state: ModuleState
//    public var charge: ModuleCharge?
//    public var possibleStates: [ModuleState]
//    
//    init(typeID: String, state: ModuleState = .online, charge: ModuleCharge? = nil) {
//        self.typeID = typeID
//        self.state = state
//        self.charge = charge
//    }
//}
//
//public class RigModule: Module {
//    public var typeID: String
//    public var state: ModuleState
//    public var possibleStates: [ModuleState] = [.offline, .online]
//    public var charge: ModuleCharge? = nil // Rigs can't have charges loaded, they're rigs...
//    
//    init(typeID: String, state: ModuleState = .online) {
//        self.typeID = typeID
//        self.state = state
//    }
//}
//
//public class SubsystemModule: Module {
//    public var typeID: String
//    public var state: ModuleState
//    public var possibleStates: [ModuleState] = [.offline, .online]
//    public var charge: ModuleCharge? = nil // Rigs can't have charges loaded, they're rigs...
//    
//    init(typeID: String, state: ModuleState = .online) {
//        self.typeID = typeID
//        self.state = state
//    }
//}
