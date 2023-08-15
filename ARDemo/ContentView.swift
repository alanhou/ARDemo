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
        let config = ARFaceTrackingConfiguration()
        config.isLightEstimationEnabled = true
        let faceAnchor = try! FaceMask.loadGlass1()
        arView.scene.addAnchor(faceAnchor)
        arView.session.delegate = arView
        arView.session.run(config, options: [])
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

var times: Int = 0

extension ARView: ARSessionDelegate{
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let estimatLight = frame.lightEstimate as? ARDirectionalLightEstimate, times < 10 else { return }
        print("light intensity: \(estimatLight.ambientIntensity),light temperature: \(estimatLight.ambientColorTemperature)")
        print("primary light direction: \(estimatLight.primaryLightDirection), primary light intensity: \(estimatLight.primaryLightIntensity)")
        times += 1
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
