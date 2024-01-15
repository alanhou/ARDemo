//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var currentState: Bool = true
    
    var body: some View {
        HStack {
            Toggle("", isOn: $currentState)
                .labelsHidden()
            Text(currentState ? "On" : "Off")
                .padding()
                .background(Color(currentState ? .yellow : .gray))
        }.padding()
    }
}

#Preview {
    ContentView()
}
