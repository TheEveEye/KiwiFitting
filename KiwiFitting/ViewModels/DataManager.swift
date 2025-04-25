//
//  DataManager.swift
//  KiwiFitting
//
//  Created by Oskar on 4/6/25.
//


// ViewModels/DataManager.swift

import Foundation
import SwiftESI

// A class that manages access to all the data files.
class DataManager: ObservableObject {
    
    // Properties to hold the data dictionaries
    @Published var InvTypes: [String: InvType] = [:]
    @Published var TypesDogma: [String: TypeDogma] = [:]
    @Published var MarketGroups: [String: MarketGroup] = [:]
    
    init() {
        loadData()
    }
    
    private func loadData() {
        loadJSONData(from: "types", into: &InvTypes)
        loadJSONData(from: "typeDogma", into: &TypesDogma)
        loadJSONData(from: "marketGroups", into: &MarketGroups)
    }
    
    private func loadJSONData<T: Decodable>(from fileName: String, into data: inout [String: T]) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Failed to locate JSON file: \(fileName)")
            return
        }
        
        do {
            let rawData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([String: T].self, from: rawData)
            data = decodedData
        } catch {
            print("Error decoding JSON from \"\(fileName)\": \(error)")
        }
    }
    
    // Function to search for the typeID using the DataManager
    public func searchTypeID(for name: String) -> String? {
        if let type = self.InvTypes.first(where: { $0.value.name?["en"]?.lowercased() == name.lowercased() }) {
            return type.key
        } else {
            return nil
        }
    }
}
