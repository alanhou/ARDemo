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
    func createPlane(){
        let planeAnchor = AnchorEntity(plane: .horizontal)
        do{
            let cubeMesh = MeshResource.generateBox(size: 0.1)
            var cubeMaterial = SimpleMaterial(color: .white, isMetallic: false)
            cubeMaterial.color = try .init(texture: .init(.load(named: "Box_Texture")))
            cubeEntity = ModelEntity(mesh: cubeMesh, materials: [cubeMaterial])
            cubeEntity!.generateCollisionShapes(recursive: false)
            cubeEntity?.name = "this is a cube"
            planeAnchor.addChild(cubeEntity!)
            self.scene.addAnchor(planeAnchor)
            self.installGestures(.all, for: cubeEntity!).forEach {
                $0.addTarget(self, action: #selector(handleModelGesture))
            }
        }catch{
            print("找不到文件")
        }
    }
    
    @objc func handleModelGesture(_ sender:Any){
        switch sender{
        case let rotation as EntityRotationGestureRecognizer:
            print("Rotation and name: \(rotation.entity!.name)")
            rotation.isEnabled = false
        case let translation as EntityTranslationGestureRecognizer:
            print("translation and name \(translation.entity!.name)")
            if translation.state == .ended || translation.state == .cancelled {
                gestureStartLocation = nil
                return
            }
            guard let gestureCurrentLocation = translation.entity?.transform.translation else {return}
            guard let _ = gestureStartLocation else {
                gestureStartLocation = gestureCurrentLocation
                return
            }
            let delta = gestureStartLocation! - gestureCurrentLocation
            let distance = ((delta.x * delta.x) + (delta.y * delta.y) + (delta.z * delta.z)).squareRoot()
            print("startLocation:\(String(describing: gestureStartLocation)),currentLocation:\(gestureCurrentLocation),the distance is \(distance)")
        case let Scale as EntityScaleGestureRecognizer:
            Scale.removeTarget(nil, action: nil)
            Scale.addTarget(self, action: #selector(handleScaleGesture))
        default:
            break
        }
    }
    
    @objc func handleScaleGesture(_ sender:EntityScaleGestureRecognizer){
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

