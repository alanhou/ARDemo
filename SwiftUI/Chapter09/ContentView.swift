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
    func loadImage(name: String) async {
        let result: String = await MainActor.run {
            myText = name
            return "Name: \(name)"
        }
        print(result)
    }
}

#Preview {
    ContentView()
}
