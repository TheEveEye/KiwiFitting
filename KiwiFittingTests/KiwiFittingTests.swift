//
//  KiwiFittingTests.swift
//  KiwiFittingTests
//
//  Created by Oskar on 4/3/25.
//

import Testing
@testable import KiwiFitting

struct KiwiFittingTests {

    @Test func testImportFittingFromEFTWithoutSubsystems() async throws {
        let exampleEFT = """
            [Venture, Cheap Venture]
            Mining Laser Upgrade I

            1MN Y-S8 Compact Afterburner
            ML-3 Scoped Survey Scanner
            Medium Shield Extender I

            EP-S Gaussian Scoped Mining Laser
            EP-S Gaussian Scoped Mining Laser

            Small EM Shield Reinforcer I
            Small Core Defense Field Extender I
            Small Core Defense Field Extender I



            Hobgoblin I x2

            5MN Quad LiF Restrained Microwarpdrive x1


            """
        
        #expect(Fitting.parseEFT(exampleEFT) == Fitting(
            name: "Cheap Venture",
            shipID: "32880",
            highSlots: ["22542"],
            midSlots: ["6001", "6569", "3829"],
            lowSlots: ["5239", "5239"],
            rigSlots: ["31716", "31788", "317882"],
            subsystems: nil,
            cargohold: [.init("35658", amount: 1)])
        )
    }
    @Test func testImportFittingFromEFTWithSubsystems() async throws {
        let exampleEFT = """
            [Tengu, [KIWI] 5/10 Blood Raider Runner]
            Ballistic Control System II
            Ballistic Control System II
            Ballistic Control System II

            10MN Afterburner II
            Dread Guristas Large Shield Booster
            Republic Fleet Large Cap Battery
            Gist X-Type Thermal Shield Hardener
            Domination EM Shield Hardener
            Domination EM Shield Hardener
            Missile Guidance Computer II

            Heavy Assault Missile Launcher II
            Heavy Assault Missile Launcher II
            Heavy Assault Missile Launcher II
            Heavy Assault Missile Launcher II
            Heavy Assault Missile Launcher II
            Heavy Assault Missile Launcher II
            Auto Targeting System I

            Medium Rocket Fuel Cache Partition II
            Medium Capacitor Control Circuit II
            Medium Ancillary Current Router I

            Tengu Core - Augmented Graviton Reactor
            Tengu Defensive - Amplification Node
            Tengu Offensive - Accelerated Ejection Bay
            Tengu Propulsion - Fuel Catalyst



            ECCM Script x1
            Scan Resolution Script x1
            Mjolnir Javelin Heavy Assault Missile x4000
            Targeting Range Script x1
            Missile Range Script x1
            Missile Precision Script x1
            Mjolnir Fury Light Missile x6000
            Caldari Navy Mjolnir Heavy Assault Missile x4000
            Mjolnir Rage Heavy Assault Missile x4000
            Sensor Booster II x1
            Covert Ops Cloaking Device II x1
            Medium Low Friction Nozzle Joints I x1
            Rapid Light Missile Launcher II x6
            Inertial Stabilizers II x1


            """
    }
}
