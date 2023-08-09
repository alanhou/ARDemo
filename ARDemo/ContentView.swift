//
//  ContentView.swift
//  ARDemo
//
//  Created by Alan on 8/8/23.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.automaticallyConfigureSession = false
        let config = ARWorldTrackingConfiguration()
//        直接设置语义开启场景深度Depth API
        if type(of: config).supportsFrameSemantics(.sceneDepth) {
            config.frameSemantics = .sceneDepth
        }
//        启用人形遮挡时自动开启场景深度Depth API
//        let semantics:ARConfiguration.FrameSemantics = [.personSegmentationWithDepth]
//        if type(of: config).supportsFrameSemantics(semantics) {
//            config.frameSemantics = semantics
//        }
        arView.session.run(config)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

