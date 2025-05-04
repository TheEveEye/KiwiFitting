//
//  SlotState.swift
//  KiwiFitting
//
//  Created by Oskar on 5/4/25.
//

import Foundation
import SwiftUI

public enum SlotState {
    case empty
    case disabled
    case online
    case offline
    case overload
    case active
    mutating func advance() {
        switch self {
        case .empty:
            self = .disabled
        case .disabled:
            self = .online
        case .online:
            self = .offline
        case .offline:
            self = .overload
        case .overload:
            self = .active
        case .active:
            self = .empty
        }
    }
}

extension SlotState {
    var frameFillColor: Color {
        switch self {
        case .empty:
            return .clear
        case .disabled:
            return .clear
        case .online:
            return .gray.opacity(0.2)
        case .offline:
            return .gray.opacity(0.1)
        case .overload:
            return .red.opacity(0.2)
        case .active:
            return .green.opacity(0.2)
        }
    }
    var frameStrokeColor: Color {
        switch self {
            
        case .empty:
            return .gray
        case .disabled:
            return .gray.opacity(0.2)
        case .online:
            return .gray
        case .offline:
            return .gray.opacity(0.5)
        case .overload:
            return .red
        case .active:
            return .green
        }
    }
    var imageOpacity: Double {
        switch self {
        case .disabled:
            return 0
        case .offline:
            return 0.5
        default:
            return 1
        }
    }
}
