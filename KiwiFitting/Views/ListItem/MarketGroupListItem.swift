//
//  MarketGroupListItem.swift
//  KiwiFitting
//
//  Created by Oskar on 13.04.25.
//

import SwiftUI
import SwiftESI
import KiwiUtilities

struct MarketGroupListItem: View {
    let marketGroup: MarketGroup
    @State private var isExpanded: Bool = false
    
    private var dataManager = DataManager()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.\(isExpanded ? "down" : "right")")
                AsyncImage(url: URL(string: "https://images.evetech.net/types/\(marketGroup.iconID?.description ?? "0")/icon")) { image in
                    image
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 32, height: 32)
                Text(marketGroup.nameID?["en"] ?? "Unknown")
                Spacer()
            }
            .onTapGesture {
                isExpanded.toggle()
            }
            if isExpanded {
                if marketGroup.hasTypes {
                    let types = fetchTypes()
                    ForEach(types.sorted(by: { $0.key < $1.key }), id: \.key) { key, type in
                        TypeListItem(type)
                    }
                }
                else {
                    
                }
            }
        }
    }
    
    init(_ marketGroup: MarketGroup) {
        self.marketGroup = marketGroup
    }
    
    private func fetchTypes() -> [String : InvType] {
        if let marketGroupID = dataManager.MarketGroups.keyof(for: marketGroup) {
            let types: [String: InvType] = dataManager.InvTypes.filter { $0.value.marketGroupID?.description == marketGroupID }
            return types
        }
        return [:]
    }
//    private func fetchMarketGroupChildren() -> [String : MarketGroup] {
//        
//    }
}

#Preview {
    let dataManager = DataManager()
    MarketGroupListItem(dataManager.MarketGroups["2146"]!)
}
