//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var color = Color.clear
    @State private var buttonDisabled = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Default Title")
                .padding()
                .background(color)
            Button("Change Color") {
                color = Color.green
                buttonDisabled = true
            }
            .disabled(buttonDisabled)
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
