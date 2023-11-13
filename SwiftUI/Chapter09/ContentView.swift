//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var myText: String = "Hello, world!"
    
    var body: some View {
        VStack {
            Text(myText)
                .padding()
        }.onAppear {
            Task(priority: .background) {
                await loadImage(name: "image1")
            }
        }
    }
    @MainActor func loadImage(name: String) async {
        myText = name
    }
}

#Preview {
    ContentView()
}
