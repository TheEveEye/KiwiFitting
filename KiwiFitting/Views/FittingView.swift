//
//  FittingView.swift
//  KiwiFitting
//
//  Created by Oskar on 4/3/25.
//

import SwiftUI

struct FittingView: View {
    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()
            
            // Circular UI Elements
            Circle()
                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                .frame(width: 350, height: 350)
                
            // Ship Preview (Placeholder for now)
            Image(systemName: "airplane") // Replace with actual ship render
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.blue)
                
            // Module Slots (Positioned around the circle)
            ForEach(0..<8) { index in
                Circle()
                    .fill(Color.orange.opacity(0.7))
                    .frame(width: 40, height: 40)
                    .overlay(Image(systemName: "shield.lefthalf.filled")
                        .foregroundColor(.white))
                    .position(circularPosition(index: index, total: 8, radius: 180))
            }
            
            // CPU and Power Grid
            VStack {
                Spacer()
                HStack {
                    Text("CPU: 34.0/687.5")
                        .font(.caption)
                        .foregroundColor(.white)
                    Spacer()
                    Text("Power Grid: 446.0/1,007.0")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding()
            }
        }
    }
    
    // Calculate positions for circular layout
    func circularPosition(index: Int, total: Int, radius: CGFloat) -> CGPoint {
        let angle = (Double(index) / Double(total)) * 2 * .pi
        return CGPoint(x: _math.cos(angle) * radius + 200, y: sin(angle) * radius + 200)
    }
}

#Preview {
    FittingView()
        .frame(width: 480, height: 360)
}
