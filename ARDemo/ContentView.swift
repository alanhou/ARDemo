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

var cubeEntity: ModelEntity?
var gestureStartLocation: SIMD3<Float>?

extension ARView: ARSessionDelegate{
    func createPlane() {
        let planeAnchor = AnchorEntity(plane: .horizontal)
        do {
            let cubeMesh = MeshResource.generateBox(size: 0.1)
            var cubeMaterial = SimpleMaterial(color: .white, isMetallic: false)
            cubeMaterial.color = try .init(texture: .init(.load(named: "Box_Texture")))
            cubeEntity = ModelEntity(mesh: cubeMesh, materials: [cubeMaterial])
            cubeEntity?.generateCollisionShapes(recursive: false)
            cubeEntity?.name = "this is a cube"
            planeAnchor.addChild(cubeEntity!)
            self.scene.addAnchor(planeAnchor)
            self.installGestures(.all, for: cubeEntity!).forEach{
                $0.addTarget(self, action: #selector(handleModelGesture))
            }
        } catch {
            print("找不到文件")
        }
    }
    
    @objc func handleModelGesture(_ sender: Any) {
        switch sender {
        case let rotation as EntityRotationGestureRecognizer:
            rotation.isEnabled = false
            var transform = rotation.entity!.transform
            transform.rotation = simd_quatf(angle: .pi * 1.5, axis: [0, 1, 0])
            rotation.entity?.move(to: transform, relativeTo: nil, duration: 5.0)
            rotation.isEnabled = true
        case let translation as EntityTranslationGestureRecognizer:
            translation.isEnabled = false
            var transform = translation.entity!.transform
            transform.translation = SIMD3<Float>(x: 0.8, y: 0, z: 0)
            translation.entity?.move(to: transform, relativeTo: nil, duration: 5.0)
            translation.isEnabled = true
        case let Scale as EntityScaleGestureRecognizer:
            Scale.isEnabled = false
            var scaleTransform = Scale.entity!.transform
            scaleTransform.scale = SIMD3<Float>(x: 2, y: 2, z: 2)
            Scale.entity?.move(to: scaleTransform, relativeTo: nil, duration: 5.0)
            Scale.isEnabled = true
        default:
            break
        }
    }
    
    @objc func handleScaleGesture(_ sender: EntityScaleGestureRecognizer) {
        print("in scale")
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

