//
//  SlotView.swift
//  KiwiFitting
//
//  Created by Oskar on 20.04.25.
//

import SwiftUI

struct SlotView: View {
//    @State var moduleState: ModuleState
    var body: some View {
        AsyncImage(url: URL(string: "https://via.placeholder.com/150")!)
            .frame(width: 150, height: 150)
    }
}

#Preview {
    SlotView()
}
