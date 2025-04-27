//
//  ContentView.swift
//  KiwiFitting
//
//  Created by Oskar on 4/3/25.
//

import SwiftUI
import SwiftESI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    
    // Store the name entered by the user
    @State private var searchName: String = ""
    
    // Store the result for the searched typeID
    @State private var resultTypeID: String?

    var body: some View {
        VStack {
            // Text Field for name input
            TextField("Enter name", text: $searchName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 300)

            // Search Button to look up typeID based on entered name
            Button(action: {
                resultTypeID = dataManager.searchTypeID(for: searchName)
            }) {
                Text("Search TypeID")
                    .padding()
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            // Display the result if found
            if let typeID = resultTypeID {
                Text("TypeID: \(typeID)")
                    .padding()
            } else {
                Text("TypeID not found")
                    .padding()
            }
            if let typeID = resultTypeID {
                ScrollView {
                    Text("Effects")
                    
                    ForEach(dataManager.TypesDogma[typeID]!.dogmaEffects) {effect in
                        HStack {
                            Text(dataManager.DogmaEffects[String(effect.effectID)]?.effectName ?? "Effect not found")
                            Spacer()
                            Text(String(effect.isDefault))
                        }
                    }
                    
                    Text("Attributes")
                    
                    ForEach(dataManager.TypesDogma[typeID]!.dogmaAttributes) {attribute in
                        HStack {
                            Text(dataManager.DogmaAttributes[String(attribute.attributeID)]?.name ?? "Effect not found")
                            Spacer()
                            Text(String(attribute.value))
                        }
                    }
                }
            }
            
        }
        .padding()
    }
    
}

#Preview {
    ContentView()
}
