//
//  ContentView.swift
//  ARDemo
//
//  Created by Alan on 8/8/23.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.environmentTexturing = .none
        arView.session.delegate = arView
        arView.session.run(config, options: [])
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

var times: Int = 0

extension ARView: ARSessionDelegate{
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let anchor = anchors.first as? ARPlaneAnchor else {return}
        let planeAnchor = AnchorEntity(anchor: anchor)
        let sphereRadius: Float = 0.1
        let sphere: MeshResource = .generateSphere(radius: sphereRadius)
        let sphereMaterial = SimpleMaterial(color: .blue, isMetallic: true)
        let sphereEntity = ModelEntity(mesh: sphere, materials: [sphereMaterial])
        sphereEntity.transform.translation = [0, planeAnchor.transform.translation.y+0.05, 0]
        planeAnchor.addChild(sphereEntity)
        self.scene.addAnchor(planeAnchor)
        self.session.delegate = nil
        self.session.run(ARWorldTrackingConfiguration())
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
