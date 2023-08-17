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
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("当前设备不支持人体肢体捕捉")
        }
        let config = ARBodyTrackingConfiguration()
        config.automaticSkeletonScaleEstimationEnabled = true
        config.frameSemantics = .bodyDetection
        arView.session.delegate = arView
        arView.createSphere()
        arView.session.run(config)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

var leftEye: ModelEntity!
var rightEye: ModelEntity!
var eyeAnchor = AnchorEntity()

extension ARView: ARSessionDelegate{
    func createSphere() {
        let eyeMat = SimpleMaterial(color: .green, isMetallic: true)
        leftEye = ModelEntity(mesh: .generateSphere(radius: 0.02), materials: [eyeMat])
        rightEye = ModelEntity(mesh: .generateSphere(radius: 0.02), materials: [eyeMat])
        eyeAnchor.addChild(leftEye)
        eyeAnchor.addChild(rightEye)
        self.scene.addAnchor(eyeAnchor)
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            guard let leftEyeMatrix = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_eye_joint")), let rightEyeMatrix = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "right_eye_joint")) else { return }
            let posLeftEye = simd_make_float3(leftEyeMatrix.columns.3)
            leftEye.position = posLeftEye
            let posRightEye = simd_make_float3(rightEyeMatrix.columns.3)
            rightEye.position = posRightEye
            eyeAnchor.position = bodyPosition
            eyeAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
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
