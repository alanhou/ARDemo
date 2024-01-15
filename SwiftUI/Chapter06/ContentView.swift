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
        VStack {
            Toggle(isOn: $currentState, label: {
                Text(currentState ? "On" : "Off")
                Text("Enable or Disable")
            })
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
