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

var arView: ARView!

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        arView = ARView(frame: .zero)
        guard ARGeoTrackingConfiguration.isSupported else { return arView }
        ARGeoTrackingConfiguration.checkAvailability{ (available, error) in
            guard available else { return }
            arView.session.run(ARGeoTrackingConfiguration())
        }
        
        arView.session.delegate = arView
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}


extension ARView: ARSessionDelegate{
    public func session(_ session: ARSession, didChange geoTrackingStatus: ARGeoTrackingStatus) {
        var text = geoTrackingStatus.state.rawValue.description
        if geoTrackingStatus.state == .localized {
            text += "Accuracy: \(geoTrackingStatus.accuracy.rawValue.description)"
        } else {
            switch geoTrackingStatus.stateReason {
            case .none:
                break
            case .worldTrackingUnstable:
                let arTrackingState = session.currentFrame?.camera.trackingState
                if case let .limited(arTrackingStateReason) = arTrackingState{
                    text += "\n\(geoTrackingStatus.stateReason.rawValue.description): \(arTrackingStateReason)."
                } else {
                    fallthrough
                }
            default:
                text += "\n\(geoTrackingStatus.stateReason.rawValue.description)."
            }
        }
        print(text)
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

