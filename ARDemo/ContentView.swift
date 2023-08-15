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
        config.isLightEstimationEnabled = true
        arView.session.delegate = arView
        arView.session.run(config, options: [])
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

var isPlaced = false
var times: Int = 0

extension ARView: ARSessionDelegate{
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let anchor = anchors.first as? ARPlaneAnchor, !isPlaced else {
            return
        }
        do {
            let planeAnchor = AnchorEntity(anchor: anchor)
            let box: MeshResource = .generateBox(size: 0.1, cornerRadius: 0.003)
            var boxMaterial = SimpleMaterial(color: .blue, isMetallic: false)
            boxMaterial.color = try .init(texture: .init(.load(named: "Box_Texture")))
            boxMaterial.roughness = 0.8
            let boxEntity = ModelEntity(mesh: box, materials: [boxMaterial])
            planeAnchor.addChild(boxEntity)
            self.installGestures(for: boxEntity)
            self.scene.addAnchor(planeAnchor)
            isPlaced = true
        } catch {
            print("无法加载图片纹理")
        }
    }
    
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let estimatLight = frame.lightEstimate , times < 10 else {return }
        print("light intensity: \(estimatLight.ambientIntensity),light temperature: \(estimatLight.ambientColorTemperature)")
        times += 1
        ARLightEstimate.self
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
