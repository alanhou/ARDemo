//
//  visionOSDemoApp.swift
//  visionOSDemo
//
//  Created by Alan on 2023/11/20.
//

import SwiftUI
import RealityKit

@main
struct visionOSDemoApp: App {
    @StateObject var model = ViewModel()
    
    var body: some SwiftUI.Scene {
        ImmersiveSpace {
            RealityView { content in
                content.add(model.setupContentEntity())
            }
            .task{
                await model.runSession()
            }
        }
    }
}
