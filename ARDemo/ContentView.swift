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

var arView: ARView!

struct ContentView : View {
    var body: some View {
        ARViewContainer()
            .overlay(
                VStack{
                    Spacer()
                    HStack{
                        Button(action: {arView.changeObjectsLibrary()}){
                            Text("切换图像库")
                                .frame(width: 200, height: 40)
                                .font(.title)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .opacity(0.6)
                        }
                        .offset(y: -30)
                        .padding(.bottom, 30)
                        .padding(.leading, 20)
                    }
                }
            )
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        guard let trackedObjectsLib = ARReferenceObject.referenceObjects(inGroupNamed: "ReferenceObjectsLibrary", bundle: Bundle.main) else {
            fatalError("无法加载参考物体库")
        }
//        var trackedObjectsLib = Set<ARReferenceObject>()
//        let objURL = Bundle.main.url(forResource: "objBook", withExtension: "arobject")
//        do {
//            let  newReferenceObject = try ARReferenceObject(archiveURL: objURL!)
//            trackedObjectsLib.insert(newReferenceObject)
//        } catch {
//            fatalError("无法加载参数物体")
//        }
        
        config.detectionObjects = trackedObjectsLib
        config.maximumNumberOfTrackedImages = 1
        arView.session.run(config, options: [])
        arView.session.delegate = arView
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView: ARSessionDelegate{
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let objectAnchor = anchors[0] as? ARObjectAnchor else {
            return
        }
        let referenceObjectName = objectAnchor.referenceObject.name == "Book" ? "toy_bigplane" : "toy_drummer"
        DispatchQueue.main.async {
            do {
                let myModelEntity = try Entity.load(named: referenceObjectName)
                let objectAnchorEntity = AnchorEntity(anchor: objectAnchor)
                objectAnchorEntity.addChild(myModelEntity)
                self.scene.addAnchor(objectAnchorEntity)
            } catch {
                print("无法加载模型")
            }
        }
    }
    
    func changeObjectsLibrary(){
        let config = self.session.configuration as! ARWorldTrackingConfiguration
        guard let detectedObjectsLib = ARReferenceObject.referenceObjects(inGroupNamed: "ReferenceObjectsLibrary2", bundle: Bundle.main) else {
            fatalError("无法加载参考物体")
        }
        config.detectionObjects = detectedObjectsLib
        self.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        print("参考物体库切换成功")
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
