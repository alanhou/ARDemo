//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var currentValue: Double = 0
    
    var body: some View {
        VStack {
            Text("Current Value: \(currentValue.formatted(.number.precision(.fractionLength(0))))")
            Stepper("Counter", value: $currentValue, in: 0...100, step: 5)
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
