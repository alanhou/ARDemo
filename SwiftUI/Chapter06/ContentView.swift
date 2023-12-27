//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct MyStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        return configuration.label
            .padding()
            .border(Color.green, width: 5)
            .scaleEffect(pressed ? 1.2 : 1.0)
    }
}

struct ContentView: View {
    @State private var color = Color.gray
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Default title")
                .padding().foregroundColor(color)
            Button("Change Color") {
                color = Color.green
            }.buttonStyle(MyStyle())
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
