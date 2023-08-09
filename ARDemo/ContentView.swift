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
        arView.createRobot()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView: ARSessionDelegate{
    func createRobot() {
        let planeAnchor = AnchorEntity(plane: .horizontal)
        do {
            let robot = try ModelEntity.load(named: "toy_drummer")
            planeAnchor.addChild(robot)
            robot.scale = [0.01, 0.01, 0.01]
            self.scene.addAnchor(planeAnchor)
            print("Total animation count: \(robot.availableAnimations.count)")
            robot.playAnimation(robot.availableAnimations[0].repeat())
        } catch {
            print("找不到USDZ文件")
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

