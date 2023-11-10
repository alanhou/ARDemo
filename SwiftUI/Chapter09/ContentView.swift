//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var thumbnail: String {
        get async {
            try? await Task.sleep(nanoseconds: 3 * 1000000000)
            return "mythumbnail"
        }
    }
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
        }
        .onAppear {
            Task(priority: .background) {
                let imageName = await thumbnail
                print(imageName)
            }
        }
    }
}

#Preview {
    ContentView()
}
