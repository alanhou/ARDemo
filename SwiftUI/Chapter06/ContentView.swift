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
            Text("Current Value: \(currentValue.formatted(.number.precision(.fractionLength(0))))")
            Slider(value: $currentValue, in: 0...10, step: 1.0)
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
