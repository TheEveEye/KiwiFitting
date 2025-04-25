//
//  TypeListItem.swift
//  KiwiFitting
//
//  Created by Oskar on 13.04.25.
//

import SwiftUI
import SwiftESI

struct TypeListItem: View {
    let type: InvType
    
    var body: some View {
        HStack {
            Text(type.name?["en"] ?? "Unknown")
            Spacer()
        }
        .frame(height: 32)
    }
    
    init(_ type: InvType) {
        self.type = type
    }
}

#Preview {
    let dataManager = DataManager()
    TypeListItem(dataManager.InvTypes["482"]!)
}
