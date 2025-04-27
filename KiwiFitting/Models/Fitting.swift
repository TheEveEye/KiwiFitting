////
////  Fitting.swift
////  KiwiFitting
////
////  Created by Oskar on 4/3/25.
////
//
//import Foundation
//import SwiftData
//
//@Model
//final class Fitting: Identifiable {
//    @Attribute(.unique) var id: UUID = UUID()
//    var name: String
//    var shipID: String
//    
//    var highSlots: [Module]
//    var midSlots: [Module]
//    var lowSlots: [Module]
//    var rigSlots: [Module]
//    
//    var subsystems: Subsystem?
//    
//    var cargohold: [InvItem]
//    
//    init(id: UUID = UUID(), name: String, shipID: String, highSlots: [Module] = [], midSlots: [Module] = [], lowSlots: [Module] = [], rigSlots: [Module] = [], subsystems: Subsystem? = nil, cargohold: [InvItem] = []) {
//        self.id = id
//        self.name = name
//        self.shipID = shipID
//        self.highSlots = highSlots
//        self.midSlots = midSlots
//        self.lowSlots = lowSlots
//        self.rigSlots = rigSlots
//        self.subsystems = subsystems
//        self.cargohold = cargohold
//    }
//    
//    public static func parseEFT(_ eftString: String) -> Fitting {
//        let lines = eftString.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
//        
//        var name = "Unknown Fit"
//        var shipID = ""
//        var lowSlots: [String] = []
//        var midSlots: [String] = []
//        var highSlots: [String] = []
//        var rigSlots: [String] = []
//        
//        var subsystems: Subsystem?
//        
//        var cargohold: [InvItem] = []
//        
//        let dataManager = DataManager()
//        
//        var currentSection = 0
//        var currentSubsystem = 0
//        
//        for (index, line) in lines.enumerated() {
//            if index == 0, line.contains(",") {
//                // First line: [Ship, Fit Name]
//                let parts = line.trimmingCharacters(in: CharacterSet(charactersIn: "[]")).components(separatedBy: ",")
//                if parts.count == 2 {
//                    shipID = parts[0].trimmingCharacters(in: .whitespaces)
//                    name = parts[1].trimmingCharacters(in: .whitespaces)
//                }
//                continue
//            }
//            
//            if line.isEmpty && currentSubsystem == 0 {
//                currentSection += 1
//                continue
//            }
//            
//            func appendToSlot(_ slot: inout [String], line: String, emptyLabel: String) {
//                if line == emptyLabel {
//                    slot.append("")
//                } else {
//                    let typeID = dataManager.searchTypeID(for: line) ?? ""
//                    slot.append(typeID)
//                }
//            }
//
//            switch currentSection {
//            case 0:
//                appendToSlot(&lowSlots, line: line, emptyLabel: "[Empty Low slot]")
//            case 1:
//                appendToSlot(&midSlots, line: line, emptyLabel: "[Empty Mid slot]")
//            case 2:
//                appendToSlot(&highSlots, line: line, emptyLabel: "[Empty High slot]")
//            case 3:
//                appendToSlot(&rigSlots, line: line, emptyLabel: "[Empty Rig slot]")
//            case 4: //Subsystems
//                if currentSubsystem < 3 {
//                    currentSubsystem += 1
//                    continue
//                }
//                switch currentSubsystem {
//                case 1:
//                    subsystems = Subsystem.empty()
//                    subsystems?.core = dataManager.searchTypeID(for: line) ?? ""
//                case 2:
//                    subsystems?.defensive = dataManager.searchTypeID(for: line) ?? ""
//                case 3:
//                    subsystems?.offensive = dataManager.searchTypeID(for: line) ?? ""
//                case 4:
//                    subsystems?.propulsion = dataManager.searchTypeID(for: line) ?? ""
//                default:
//                    currentSection += 1
//                }
//            default:
//                var cargoholdItem: InvItem
//                if line.split(separator: " ").last?.last == "x", let amount = Int(line.split(separator: " ").last?.dropLast() ?? "") {
//                    cargoholdItem = .init(dataManager.searchTypeID(for: line.split(separator: " ").dropLast().joined(separator: " ")) ?? "0", amount: amount)
//                } else {
//                    cargoholdItem = .init(dataManager.searchTypeID(for: line) ?? "0", stackable: false)
//                }
//                cargohold.append(cargoholdItem)
//            }
//        }
//        
//        return Fitting(
//            id: UUID(),
//            name: name,
//            shipID: shipID,
//            highSlots: highSlots,
//            midSlots: midSlots,
//            lowSlots: lowSlots,
//            rigSlots: rigSlots,
//            subsystems: subsystems,
//            cargohold: cargohold
//        )
//    }
//}
//    
//    @Model
//    final class Subsystem {
//        var propulsion: Module?
//        var defensive: Module?
//        var core: Module?
//        var offensive: Module?
//        
//        init(propulsion: Module? = nil, defensive: Module? = nil, core: Module? = nil, offensive: Module? = nil) {
//            self.propulsion = propulsion
//            self.defensive = defensive
//            self.core = core
//            self.offensive = offensive
//        }
//        
//        init(propulsion: String? = nil, defensive: String? = nil, core: String? = nil, offensive: String? = nil) {
//            self.propulsion = .init(typeID: propulsion, slot: <#T##SlotType#>, state: <#T##ModuleState#>, highSlotType: <#T##HighSlotType?#>)
//            self.defensive = defensive
//            self.core = core
//            self.offensive = offensive
//        }
//        
//        public static func empty() -> Subsystem { .init() }
//    }
