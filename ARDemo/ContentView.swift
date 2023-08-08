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

var planeMesh = MeshResource.generatePlane(width: 0.15, depth: 0.15)
var planeMaterial = SimpleMaterial(color: .white, isMetallic: false)
var planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])

extension ARView: ARSessionDelegate{
    func createPlane(){
        let planeAnchor = AnchorEntity(plane: .horizontal)
        do{
//            planeMaterial.color = try .init(tint: UIColor.yellow.withAlphaComponent(0.9999), texture: .init(.load(named: "Surface_DIFFUSE")))
            planeMaterial.baseColor = try .texture(.load(named: "Surface_DIFFUSE"))
            planeMaterial.tintColor = UIColor.yellow.withAlphaComponent(0.9999)
            planeAnchor.addChild(planeEntity)
            self.scene.addAnchor(planeAnchor)
        }catch{
            print("找不到文件")
        }
    }
    
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let pAnchor = anchors[0] as? ARPlaneAnchor else {
            return
        }
        DispatchQueue.main.async {
            planeEntity.model?.mesh = MeshResource.generatePlane(
             width: pAnchor.extent.x,
             depth: pAnchor.extent.z
           )
            planeEntity.setTransformMatrix(pAnchor.transform, relativeTo: nil)
        }
    }
    
    public func session(session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let pAnchor = anchors[0] as? ARPlaneAnchor else {
            return
        }
        DispatchQueue.main.async {
//            planeEntity.model?.mesh = MeshResource.generatePlane(width: pAnchor.planeExtent.width, depth: pAnchor.planeExtent.rotationOnYAxis)
            planeEntity.model?.mesh = MeshResource.generatePlane(
             width: pAnchor.extent.x,
             depth: pAnchor.extent.z
           )
            planeEntity.setTransformMatrix(pAnchor.transform, relativeTo: nil)
        }
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

