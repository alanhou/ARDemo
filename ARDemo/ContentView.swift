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
        config.planeDetection = [.horizontal,.vertical]
        arView.session.run(config, options: [])
        arView.debugOptions = [.showAnchorGeometry,.showAnchorOrigins,.showFeaturePoints]
        arView.createPlane()
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView: ARSessionDelegate{
    public func session(_ session: ARSession, didFailWithError error: Error) {
        guard let arError = error as? ARError else {return}
        let isRecoverable = (arError.code == .worldTrackingFailed)
        if isRecoverable{
            print("由于运动跟踪失败的错误可恢复")
        }
        else{
            print("错误不可恢复，失败Code =\(arError.code),错误描述：\(arError.localizedDescription)")
        }
    }
    
    func createPlane(){
        
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

