//
//  FittingWindow.swift
//  KiwiFitting
//
//  Created by Oskar on 18.04.25.
//

import SwiftUI

struct FittingWindow: View {
    private func slotType(for index: Int) -> SlotType {
        switch index {
        case 0..<8:
            return .high
        case 8..<16:
            return .mid
        case 16..<24:
            return .low
        case 24..<27:
            return .rig
        case 27:
            return .coreSubsystem
        case 28:
            return .defensiveSubsystem
        case 29:
            return .offensiveSubsystem
        default:
            return .propulsionSubsystem
        }
    }

    var body: some View {
        ZStack {
            ForEach(Array(slotRotations.enumerated()), id: \.offset) { index, angle in
                SlotView(slotType: slotType(for: index), module: inferModule(typeID: "3082"), rotationAngle: angle)
                    .rotationEffect(Angle(degrees: angle))
            }
        }
    }
    
    let slotRotations: [CGFloat] = [
        -129.0,
        -118.85714285714286,
        -108.71428571428571,
        -98.57142857142856,
        -88.42857142857143,
        -78.28571428571426,
        -68.14285714285714,
        -58.0,
        -39.5,
        -29.214285714285722,
        -18.92857142857143,
        -8.642857142857139,
        1.6428571428571394,
        11.92857142857143,
        22.214285714285722,
        32.5,
        49.5,
        59.78571428571428,
        70.07142857142856,
        80.35714285714286,
        90.64285714285714,
        100.92857142857142,
        111.21428571428571,
        121.5,
         -145.5,
        -156.0,
        -166.5,
        -220.5,
        -207.83333333333334,
        -195.16666666666669,
        -182.5
    ]
}

#Preview {
    FittingWindow()
}
