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
            let myTask = Task(priority: .background) {
                let imageName = await loadImage(name: "image1")
                print(imageName)
            }
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                print("The time is up")
                myTask.cancel()
            }
        }
    }
    func loadImage(name: String) async -> String {
        try? await Task.sleep(nanoseconds: 3 * 1000000000)
        if !Task.isCancelled {
            return "Name: \(name)"
        } else {
            return "Task Cancelled"
        }
    }
}

#Preview {
    ContentView()
}
