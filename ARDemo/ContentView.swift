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
                        Button(action: {arView.changeImagesLibrary()}){
                            Text("切换图像库")
                                .frame(width: 200, height: 400)
                                .font(.title)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .opacity(0.6)
                        }
                        .offset(y: -30)
                        .padding(.bottom, 30)
                        .padding(.leading, 20)
                        Spacer()
                        Button(action: {arView.addReferenceImage()}){
                            Text("添加参考图像")
                                .frame(width: 200, height: 400)
                                .font(.title)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .opacity(0.6)
                        }
                        .offset(y: -30)
                        .padding(.bottom, 30)
                        .padding(.trailing, 20)
                    }
                }
            )
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        arView = ARView(frame: .zero)
        let config = ARImageTrackingConfiguration()
        guard let trackedImagesLib = ARReferenceImage.referenceImages(inGroupNamed: "ReferenceImagesLibrary", bundle: Bundle.main) else {
            fatalError("无法加载参考图像库")
        }
//        var trackedImagesLib = Set<ARReferenceImage>()
//        let image = UIImage(named: "toy_biplane")
//        let referenceIMage = ARReferenceImage(image!.cgImage!, orientation: .up, physicalWidth: 0.15)
//        trackedImagesLib.insert(referenceIMage)
        
        config.trackingImages = trackedImagesLib
        config.maximumNumberOfTrackedImages = 1
        arView.session.run(config, options: [])
        arView.session.delegate = arView
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView: ARSessionDelegate{
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let imageAnchor = anchors[0] as? ARImageAnchor else {
            return
        }
        let referenceImageName = imageAnchor.referenceImage.name ?? "toy_biplane"
        DispatchQueue.main.async {
            do {
                let myModelEntity = try Entity.load(named: referenceImageName)
                let imageAnchorEntity = AnchorEntity(anchor: imageAnchor)
                imageAnchorEntity.addChild(myModelEntity)
                self.scene.addAnchor(imageAnchorEntity)
            } catch {
                print("无法加载模型")
            }
        }
    }
    
    func changeImagesLibrary(){
        let config = self.session.configuration as! ARImageTrackingConfiguration
        guard let trackedImagesLib = ARReferenceImage.referenceImages(inGroupNamed: "ReferenceImagesLibrary2", bundle: Bundle.main) else {
            fatalError("无法加载参考图像库")
        }
        config.trackingImages = trackedImagesLib
        config.maximumNumberOfTrackedImages = 1
        self.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func addReferenceImage() {
        guard let config = self.session.configuration as? ARImageTrackingConfiguration else {return}
        let image = UIImage(named: "toy_biplane")
        let referenceImage = ARReferenceImage(image!.cgImage!, orientation: .up, physicalWidth: 0.15)
        config.trackingImages.insert(referenceImage)
        self.session.run(config, options: [])
        print("insert image OK")
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

