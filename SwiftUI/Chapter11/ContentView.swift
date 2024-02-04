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
            path.move(to: CGPoint(x: 50, y: 50))
            path.addQuadCurve(to: CGPoint(x: 50, y: 200), control: CGPoint(x: 100, y: 125))
            path.move(to: CGPoint(x: 250, y: 50))
            path.addCurve(to: CGPoint(x: 250, y: 200), control1: CGPoint(x: 200, y: 125), control2: CGPoint(x: 300, y: 125))
        }.stroke(Color.blue, lineWidth: 5)
    }
}

#Preview {
    ContentView()
}
