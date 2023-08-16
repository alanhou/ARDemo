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
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        ClearCircleLayers()
        if let detectedBody = frame.detectedBody {
            guard let interfaceOrientation = self.window?.windowScene?.interfaceOrientation else { return }
            let transform = frame.displayTransform(for: interfaceOrientation, viewportSize: self.frame.size)
            
            detectedBody.skeleton.jointLandmarks.forEach{landmark in
                let normalizedCenter = CGPoint(x: CGFloat(landmark[0]), y: CGFloat(landmark[1])).applying(transform)
                let center = normalizedCenter.applying(CGAffineTransform.identity.scaledBy(x: self.frame.width, y: self.frame.height))
                let rect = CGRect(origin: CGPoint(x: center.x - circleWidth/2, y: center.y - circleHeight/2), size: CGSize(width: circleWidth, height: circleHeight))
                let circleLayer = CAShapeLayer()
                circleLayer.path = UIBezierPath(ovalIn: rect).cgPath
                self.layer.addSublayer(circleLayer)
            }
            
            if !isPrinted {
                let jointNames = detectedBody.skeleton.definition.jointNames
                for jointName in jointNames {
                    let joint2dLandmark = detectedBody.skeleton.landmark(for: ARSkeleton.JointName(rawValue: jointName))
                    let joint2dIndex = detectedBody.skeleton.definition.index(for: ARSkeleton.JointName(rawValue: jointName))
                    print("\(jointName), \(String(describing: joint2dLandmark)), the index is \(joint2dIndex), parent index is \(detectedBody.skeleton.definition.parentIndices[joint2dIndex])")
                }
                isPrinted = true
            }
        }
    }
    
    private func ClearCircleLayers() {
        self.layer.sublayers?.compactMap{$0 as? CAShapeLayer}.forEach{$0.removeFromSuperlayer()}
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
