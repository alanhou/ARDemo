//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width / 2
                let height = width
                let posX = (geometry.size.width - width) / 2
                let posY = (geometry.size.height - height) / 2
                path.move(to: CGPoint(x: posX, y: posY))
                path.addLine(to: CGPoint(x: posX + width, y: posY))
                path.addLine(to: CGPoint(x: posX, y: posY + height))
                path.closeSubpath()
            }.stroke(Color.blue, lineWidth: 5)
        }
    }
}

#Preview {
    ContentView()
}
