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
                searchTypeID(for: searchName)
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

            Spacer()
        }
        .padding()
    }

    // Function to search for the typeID using the DataManager
    private func searchTypeID(for name: String) {
        if let type = dataManager.InvTypes.first(where: { $0.value.name?["en"]?.lowercased() == name.lowercased() }) {
            resultTypeID = type.key
        } else {
            resultTypeID = nil
        }
    }
}

#Preview {
    ContentView()
}
