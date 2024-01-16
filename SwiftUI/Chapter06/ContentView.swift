//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var currentValue: Float = 5
    
    var body: some View {
        VStack {
            ProgressView(value: currentValue, total: 10)
            Slider(value: $currentValue, in: 0...10)
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
