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
        arView.session.run(config)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

let circleWidth: CGFloat = 10
let circleHeight: CGFloat = 10
var isPrinted = false

extension ARView: ARSessionDelegate{
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            if !isPrinted {
                let jointNames = bodyAnchor.skeleton.definition.jointNames
                for jointName in jointNames {
                    let modelTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName))
                    let index = bodyAnchor.skeleton.definition.index(for: ARSkeleton.JointName(rawValue: jointName))
                    print("\(jointName), \(String(describing: modelTransform?.columns.3)), the index is \(index), parent index is \(bodyAnchor.skeleton.definition.parentIndices[index])")
                }
                isPrinted = true
            }
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
