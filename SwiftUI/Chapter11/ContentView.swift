//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        Image(.spot1)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 200)
            .scaleEffect(CGSize(width: 0.9, height: 0.9))
            .rotation3DEffect(.degrees(30), axis: (x: 0.0, y: 1.0, z: 0.0))
    }
}

#Preview {
    ContentView()
}
