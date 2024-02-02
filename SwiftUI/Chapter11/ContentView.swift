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
            path.addEllipse(in: CGRect(x: 200, y: 140, width: 20, height: 20))
        }.stroke(Color.blue, lineWidth: 5)
    }
}

#Preview {
    ContentView()
}
