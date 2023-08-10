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

var boxMesh = MeshResource.generateBox(size: 0.1)
var boxMaterial = SimpleMaterial(color: .white, isMetallic: false)
var boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])

var planeMesh = MeshResource.generatePlane(width: 0.3, depth: 0.3)
var planeMaterial = SimpleMaterial(color: .white, isMetallic: false)
var planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])

extension ARView: ARSessionDelegate{
    func createPlane(){
        let planeAnchor = AnchorEntity(plane: .horizontal, classification: .any, minimumBounds: [0.3, 0.3])
        planeAnchor.addChild(boxEntity)
        var tf = boxEntity.transform
        tf.translation = SIMD3(tf.translation.x, tf.translation.y + 0.06, tf.translation.z)
        boxEntity.move(to: tf, relativeTo: nil)
        planeAnchor.addChild(planeEntity)
        let directionalLight = DirectionalLight()
        directionalLight.light.intensity = 50000
        directionalLight.light.color = UIColor.red
        directionalLight.light.isRealWorldProxy = false
        directionalLight.look(at: [0, 0, 0], from: [0.01, 1, 0.01], relativeTo: nil)
        planeAnchor.addChild(directionalLight)
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
