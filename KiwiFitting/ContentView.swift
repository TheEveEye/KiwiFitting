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
            ScrollView {
                VStack(spacing: 20) {
                    Text("KiwiFitting")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Dogma Engine Fitting Demo")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Status: \(dogmaEngineStatus)")
                                .font(.headline)
                            Spacer()
                        }
                        
                        Button("Run Ship Fitting Test") {
                            testDogmaEngine()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .frame(maxWidth: .infinity)
                        
                        if !dataStats.isEmpty {
                            ScrollView {
                                Text(dataStats)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(12)
                                    .background(.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            .frame(maxHeight: 400)
                        }
                    }
                    .padding()
                    .background(.gray.opacity(0.05))
                    .cornerRadius(12)
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
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
                
                // Create a fitted ship example - Rifter with some basic modules
                // Ship: Rifter (587) - Basic Minmatar frigate
                // Modules: Let's add some common frigate modules
                let modules = [
                    // High slot: 125mm Gatling AutoCannon II (2873)
                    EsfModule(
                        typeID: 2873,
                        slot: EsfSlot(type: .high, index: 0),
                        state: .active,
                        charge: nil
                    ),
                    // Mid slot: 1MN Afterburner II (438)
                    EsfModule(
                        typeID: 438,
                        slot: EsfSlot(type: .medium, index: 0),
                        state: .active,
                        charge: nil
                    ),
                    // Low slot: Damage Control II (2048)
                    EsfModule(
                        typeID: 2048,
                        slot: EsfSlot(type: .low, index: 0),
                        state: .passive,
                        charge: nil
                    )
                ]
                
                let fit = EsfFit(shipTypeID: 587, modules: modules, drones: [])
                
                // Create an Info instance
                let info = SimpleInfo(data: data, fit: fit)
                
                // Calculate ship stats
                let ship = calculate(info: info)
                
                // Extract detailed stats
                let shipType = data.types[587]
                let shipName = "Rifter" // We know this is a Rifter
                
                // Get key ship attributes (common EVE ship stats)
                let hullHitPoints = ship.hull.attributes[9]?.value ?? 0  // Structure HP
                let armorHitPoints = ship.hull.attributes[265]?.value ?? 0  // Armor HP
                let shieldCapacity = ship.hull.attributes[263]?.value ?? 0  // Shield HP
                let capacitorCapacity = ship.hull.attributes[482]?.value ?? 0  // Capacitor
                let maxVelocity = ship.hull.attributes[37]?.value ?? 0  // Max velocity
                let signature = ship.hull.attributes[552]?.value ?? 0  // Signature radius
                let mass = ship.hull.attributes[4]?.value ?? 0  // Mass
                
                // Calculate EHP (Effective Hit Points)
                let totalEHP = hullHitPoints + armorHitPoints + shieldCapacity
                
                await MainActor.run {
                    dogmaEngineStatus = "✅ Success: Ship fitting calculated!"
                    dataStats = """
                    🚀 SHIP FITTING ANALYSIS
                    
                    📊 Data Loaded:
                    • \(data.types.count) ship/item types
                    • \(data.dogmaAttributes.count) dogma attributes
                    • \(data.dogmaEffects.count) dogma effects
                    • \(data.typeDogma.count) type dogma entries
                    
                    🛸 Ship: \(shipName) (ID: 587)
                    • Category: \(shipType?.resolvedCategoryID ?? 0) (Ships)
                    • Group: \(shipType?.groupID ?? 0) (Assault Frigates)
                    
                    ⚡ Defense Stats:
                    • Structure HP: \(String(format: "%.0f", hullHitPoints))
                    • Armor HP: \(String(format: "%.0f", armorHitPoints))
                    • Shield HP: \(String(format: "%.0f", shieldCapacity))
                    • Total EHP: \(String(format: "%.0f", totalEHP))
                    
                    🚄 Performance:
                    • Max Velocity: \(String(format: "%.0f", maxVelocity)) m/s
                    • Signature: \(String(format: "%.0f", signature)) m
                    • Mass: \(String(format: "%.0f", mass)) kg
                    • Capacitor: \(String(format: "%.0f", capacitorCapacity)) GJ
                    
                    🔧 Fitted Modules (\(modules.count)):
                    • High: 125mm Gatling AutoCannon II
                    • Mid: 1MN Afterburner II  
                    • Low: Damage Control II
                    
                    ✅ DogmaEngine calculations complete!
                    """
                }
                
            } catch {
                await MainActor.run {
                    dogmaEngineStatus = "❌ Failed: \(error.localizedDescription)"
                    dataStats = "Error details: \(String(describing: error))"
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
