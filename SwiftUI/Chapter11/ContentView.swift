//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 100, y: 150))
            path.addLine(to: CGPoint(x: 200, y: 150))
            path.addLine(to: CGPoint(x: 100, y: 250))
            path.closeSubpath()
        }.stroke(Color.blue, lineWidth: 5)
    }
}

#Preview {
    ContentView()
}
