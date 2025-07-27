//
//  ContentView.swift
//  KiwiFitting
//
//  Created by Oskar on 7/27/25.
//

import SwiftUI
import DogmaEngine

struct ContentView: View {
    @State private var dogmaEngineStatus: String = "Not loaded"
    @State private var dataStats: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("KiwiFitting")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Dogma Engine Test")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Status: \(dogmaEngineStatus)")
                        .font(.headline)
                    
                    if !dataStats.isEmpty {
                        Text(dataStats)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Button("Test Dogma Engine") {
                        testDogmaEngine()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("KiwiFitting")
        }
    }
    
    private func testDogmaEngine() {
        dogmaEngineStatus = "Loading..."
        dataStats = ""
        
        Task {
            do {
                // Load the DogmaEngine data from bundle
                let data = try DogmaEngine.Data.newFromBundle()
                
                // Create a simple ship fit (let's try a basic frigate)
                // Ship type ID 587 is typically a Rifter (Minmatar frigate)
                let fit = EsfFit(shipTypeID: 587, modules: [], drones: [])
                
                // Create an Info instance
                let info = SimpleInfo(data: data, fit: fit)
                
                // Calculate ship stats
                let ship = calculate(info: info)
                
                // Extract some basic stats
                let shipType = data.types[587]
                let shipName = shipType != nil ? "Ship ID \(587)" : "Unknown Ship"
                
                await MainActor.run {
                    dogmaEngineStatus = "✅ Success: DogmaEngine calculation complete!"
                    dataStats = """
                    Data loaded:
                    • \(data.types.count) ship/item types
                    • \(data.dogmaAttributes.count) dogma attributes
                    • \(data.dogmaEffects.count) dogma effects
                    • \(data.typeDogma.count) type dogma entries
                    
                    Test Calculation:
                    • Ship: \(shipName)
                    • Category ID: \(shipType?.resolvedCategoryID ?? 0)
                    • Group ID: \(shipType?.groupID ?? 0)
                    
                    ✅ DogmaEngine is working!
                    """
                }
                
            } catch {
                await MainActor.run {
                    dogmaEngineStatus = "❌ Failed: \(error.localizedDescription)"
                    dataStats = "Error details: \(error)"
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
