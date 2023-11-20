//
//  ContentView.swift
//  visionOSDemo
//
//  Created by Alan on 2023/11/20.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    private let url = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/teapot/teapot.usdz")!
    
    var body: some View {
        VStack {
            Text("Show teapot")
            Model3D(url: url) { model in
                model
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            } placeholder: {
                ProgressView()
            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
