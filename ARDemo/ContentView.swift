//
//  ContentView.swift
//  ARDemo
//
//  Created by Alan on 8/8/23.
//

import SwiftUI
import RealityKit
import ARKit

struct ManualProbe {
    var objectProbeAnchor: AREnvironmentProbeAnchor?
    var requiresRefresh: Bool = false
    var lastUpdateTime: TimeInterval = Date().timeIntervalSince1970
    var dateTime = Date()
    var sphereEntity: ModelEntity!
    var isPlanced = false
}

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
        arView.automaticallyConfigureSession = false
        config.isLightEstimationEnabled = true
        config.environmentTexturing = .manual
        arView.session.delegate = arView
        arView.session.run(config, options: [])
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

var manualProbe = ManualProbe()

extension ARView: ARSessionDelegate{
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let anchor = anchors.first as? ARPlaneAnchor, !manualProbe.isPlanced else {return}
        let planeAnchor = AnchorEntity(anchor: anchor)
        let sphereRadius: Float = 0.1
        let sphere: MeshResource = .generateSphere(radius: sphereRadius)
        let sphereMaterial = SimpleMaterial(color: .blue, isMetallic: true)
        manualProbe.sphereEntity = ModelEntity(mesh: sphere, materials: [sphereMaterial])
        manualProbe.sphereEntity.transform.translation = [0, planeAnchor.transform.translation.y+0.05, 0]
        manualProbe.requiresRefresh = true
        updateProbe()
        planeAnchor.addChild(manualProbe.sphereEntity)
        self.scene.addAnchor(planeAnchor)
        self.session.run(ARWorldTrackingConfiguration())
    }
    
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if manualProbe.requiresRefresh && (manualProbe.dateTime.timeIntervalSince1970 - manualProbe.lastUpdateTime > 1) {
            manualProbe.lastUpdateTime = manualProbe.dateTime.timeIntervalSince1970
            updateProbe()
        }
    }
    
    func updateProbe() {
        if let probeAnchor = manualProbe.objectProbeAnchor {
            self.session.remove(anchor: probeAnchor)
            manualProbe.objectProbeAnchor = nil
        }
        var extent = (manualProbe.sphereEntity.model?.mesh.bounds.extents)! * manualProbe.sphereEntity.transform.scale
        extent.x *= 3
        extent.z *= 3
        let verticalOffset = SIMD3(0, extent.y, 0)
        var probeTransform = manualProbe.sphereEntity.transform
        probeTransform.translation += verticalOffset
        let position = simd_float4x4(
            SIMD4(1, 0, 0, 0),
            SIMD4(0, 1, 0, 0),
            SIMD4(0, 0, 1, 0),
            SIMD4(manualProbe.sphereEntity.transform.translation, 1)
        )
        extent.y *= 2
        manualProbe.objectProbeAnchor = AREnvironmentProbeAnchor(name: "objectProbe", transform: position, extent: extent)
        self.session.add(anchor: manualProbe.objectProbeAnchor!)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
