//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Rectangle()
            .fill(.image(Image(.pattern)))
            .frame(width: 100, height: 100)
    }
}

#Preview {
    ContentView()
}
