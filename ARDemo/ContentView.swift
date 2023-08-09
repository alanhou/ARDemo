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
        arView.addCoaching()
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(coachingOverlay)
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.delegate = self
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        self.placeBox()
    }
    
    @objc func placeBox(){
        let boxMesh = MeshResource.generateBox(size: 0.15)
        var boxMaterial = SimpleMaterial(color: .white, isMetallic: false)
        let planeAnchor = AnchorEntity(plane: .horizontal)
        do {
            boxMaterial.color = try .init(tint: UIColor.white.withAlphaComponent(0.9999), texture: .init(.load(named: "Box_Texture")))
            let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
            planeAnchor.addChild(boxEntity)
            self.scene.addAnchor(planeAnchor)
        } catch{
          print("找不到文件")
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

