//
//  ImmersiveView.swift
//  visionOSDemo
//
//  Created by Alan on 2023/11/21.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @State var model = ViewModel()
    @State var cube1 = ModelEntity()
    @State var cube2 = ModelEntity()
        
    var body: some View {
        RealityView { content, attachments in
            content.add(model.setupContentEntity())
            cube1 = model.addCube(name: "Cube1", position: SIMD3<Float>(x: 1, y: 1, z: -2), color: .red)
            cube2 = model.addCube(name: "Cube2", position: SIMD3<Float>(x: -1, y: 1, z: -2), color: .blue)
            
            if let attachment = attachments.entity(for: "cube1_label") {
                attachment.position = [0, -0.35, 0]
                cube1.addChild(attachment)
            }
            
            if let attachment = attachments.entity(for: "cube2_label") {
                attachment.position = [0, -0.35, 0]
                cube2.addChild(attachment)
            }
        } attachments: {
            Attachment(id: "cube1_label") {
                Text("Cube1")
                    .font(.system(size: 48))
            }
            Attachment(id: "cube2_label") {
                Text("Cube2")
                    .font(.system(size: 48))
            }
        }
        .gesture(
            SpatialTapGesture()
                .targetedToEntity(cube1)
                .onEnded { value in
                    print(value)
                    model.playAnimation(entity: cube1)
                }
        )
        .gesture(
            SpatialTapGesture()
                .targetedToEntity(cube2)
                .onEnded { value in
                    print(value)
                    model.playAnimation(entity: cube2)
                }
        )
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
