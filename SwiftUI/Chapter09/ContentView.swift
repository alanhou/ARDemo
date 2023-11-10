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
        .task(priority: .background) {
            let imageName1 = await loadImage(name: "image1")
            let imageName2 = await loadImage(name: "image2")
            let imageName3 = await loadImage(name: "image3")
            print("\(imageName1), \(imageName2), \(imageName3)")
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
