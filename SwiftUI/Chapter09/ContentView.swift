//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

enum MyErrors: Error {
    case noData, noImage
}
struct ContentView: View {
   
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
        }
        .onAppear {
            Task(priority: .background) {
                do {
                    let imageName = try await loadImage(name: "image1")
                    print(imageName)
                } catch MyErrors.noData {
                    print("Error: No Data Available")
                } catch MyErrors.noImage {
                    print("Error: No Image Available")
                }
            }
        }
    }
    func loadImage(name: String) async throws -> String {
        try? await Task.sleep(nanoseconds: 3 * 1000000000)
        
        let error = true
        if error {
            throw MyErrors.noImage
        }
        return "Name: \(name)"
    }
}

#Preview {
    ContentView()
}
