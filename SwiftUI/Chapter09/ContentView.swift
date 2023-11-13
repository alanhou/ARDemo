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
          Text("Hello World!")
                .padding()
        }.onAppear {
            Task(priority: .background) {
                await withTaskGroup(of: String.self) { group in
                    group.addTask(priority: .background) {
                        let imageName = await self.loadImage(name: "image1")
                        return imageName
                    }
                    group.addTask(priority: .background) {
                        let imageName = await self.loadImage(name: "image2")
                        return imageName
                    }
                    group.addTask(priority: .background) {
                        let imageName = await self.loadImage(name: "image3")
                        return imageName
                    }
                    for await result in group {
                        print(result)
                    }
                }
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
