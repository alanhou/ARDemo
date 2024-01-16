//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var currentValue: Float = 5
    @State private var textAcitve: Bool = false
    
    var body: some View {
        VStack {
            Text("Current Value: \(currentValue.formatted(.number.precision(.fractionLength(0))))")
                .padding()
                .background(textAcitve ? Color.yellow : Color.clear)
            Slider(value: $currentValue, in: 0...10, step: 1.0, onEditingChanged: { self.textAcitve = $0 })
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
