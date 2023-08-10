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
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.worldAlignment = .gravity
        arView.session.run(config, options: [])
        arView.session.delegate = arView
        arView.createPlane()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

var planeMesh = MeshResource.generatePlane(width: 0.3, depth: 0.3)
var planeMaterial = SimpleMaterial(color: .white, isMetallic: false)
var planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])

extension ARView: ARSessionDelegate{
    func createPlane(){
        let planeAnchor = AnchorEntity(plane: .horizontal, classification: .any, minimumBounds: [0.3, 0.3])
        planeAnchor.addChild(planeEntity)
        let l = SpotLight()
        l.light = SpotLightComponent(color: .yellow, intensity: 5000, innerAngleInDegrees: 5, outerAngleInDegrees: 80, attenuationRadius: 2)
        l.position = [planeEntity.position.x, planeEntity.position.y + 0.1, planeEntity.position.z + 0.5]
        l.move(to: l.transform, relativeTo: nil)
        let lightAnchor = AnchorEntity(world: l.position)
        lightAnchor.components.set(l.light)
        self.scene.addAnchor(lightAnchor)
        self.scene.addAnchor(planeAnchor)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
