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
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(ARConfiguration.FrameSemantics.personSegmentationWithDepth) else {
            fatalError("当前设备不支持人形遮挡")
        }
        let config = ARBodyTrackingConfiguration()
        config.frameSemantics = .personSegmentationWithDepth
        config.planeDetection = .horizontal
        arView.session.delegate = arView
        arView.session.run(config)
        arView.loadModel()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

var robotCharacter: BodyTrackedEntity?
let robotOffset: SIMD3<Float> = [-1, 0, 0, 0]
let robotAnchor = AnchorEntity()

extension ARView: ARSessionDelegate{
    func loadModel(){
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadModelAsync(named: "fender_stratocaster.usdz").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("无法加载模型,错误：\(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { entity in
            let planeAnchor = AnchorEntity(plane:.horizontal)
            planeAnchor.addChild(entity)
            self.scene.addAnchor(planeAnchor)
            cancellable?.cancel()
        })
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
