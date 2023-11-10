//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
        }
        .onAppear {
            let currentTime = Date()
            Task(priority: .background) {
               async let imageName1 = loadImage(name: "image1")
               async let imageName2 = loadImage(name: "image2")
               async let imageName3 = loadImage(name: "image3")
                
                let listNames = await "\(imageName1), \(imageName2), \(imageName3)"
                print(listNames)
                print("Total Time: \(Date().timeIntervalSince(currentTime))")
            }
        }
    }
    func loadImage(name: String) async -> String {
        try? await Task.sleep(nanoseconds: 3 * 1000000000)
        return "Name: \(name)"
    }
}

#Preview {
    ContentView()
}
