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
            Toggle(isOn: $currentState, label: {
                Label("Send", systemImage: "mail")
            })
            .toggleStyle(.button)
        }.padding()
    }
}

#Preview {
    ContentView()
}
