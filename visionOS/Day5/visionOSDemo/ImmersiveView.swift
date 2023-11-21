//
//  ImmersiveView.swift
//  visionOSDemo
//
//  Created by Alan on 2023/11/21.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @StateObject var model = ViewModel()
    
    private var contentEntity = Entity()
    
    var body: some View {
        RealityView { content in
            content.add(model.setupContentEntity())
            model.addCube()
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
