//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ImageIterator: AsyncIteratorProtocol {
    let imageList: [String]
    var current = 0
    
    mutating func next() async -> String? {
        guard current < imageList.count else {
            return nil
        }
        try? await Task.sleep(nanoseconds: 3 * 1000000000)
        let image = imageList[current]
        current += 1
        return image
    }
}

struct ImageLoader: AsyncSequence {
    typealias Element = String
    let imageList: [String]
    
    func makeAsyncIterator() -> ImageIterator {
        return AsyncIterator(imageList: imageList)
    }
}

struct ContentView: View {
    let list = ["image1", "image2", "image3"]
    
    var body: some View {
        VStack {
          Text("Hello World!")
                .padding()
        }.onAppear {
            Task(priority: .background) {
                let loader = ImageLoader(imageList: list)
                for await image in loader {
                    print(image)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
