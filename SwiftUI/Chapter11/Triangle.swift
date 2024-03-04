//
//  Triangle.swift
//  Test
//
//  Created by Alan on 2024/3/4.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let posX = rect.origin.x
        let posY = rect.origin.y
        
        path.move(to: CGPoint(x: posX, y: posY))
        path.addLine(to: CGPoint(x: posX + width, y: posY))
        path.addLine(to: CGPoint(x: posX, y: posY + height))
        path.closeSubpath()
        
        return path
    }
}
