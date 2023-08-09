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
        ARViewContainer()
            .overlay(
                VStack{
                    Spacer()
                    HStack{
                        Button(action: {arView.snapShotAR()}) {
                            Text("AR截图")
                                .frame(width: 120, height: 40)
                                .font(.body)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .opacity(0.6)
                        }
                        .offset(y: -30)
                        .padding(.bottom, 30)
                        Button(action: {arView.snapShotCamera()}) {
                            Text("摄像机截图")
                            .frame(width:120,height:40)
                            .font(.body)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .opacity(0.6)
                        }
                        .offset(y: -30)
                        .padding(.bottom, 30)
                    }
                }
            ).edgesIgnoringSafeArea(.all)
    }
}

var arView : ARView!

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config, options: [])
        arView.session.delegate = arView
        arView.createPlane()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}


extension ARView: ARSessionDelegate{
    func createPlane() {
        let planeAnchor = AnchorEntity(plane: .horizontal)
        do{
            let cubeMesh = MeshResource.generateBox(size: 0.2)
            var cubeMaterial = SimpleMaterial(color: .white, isMetallic: false)
            cubeMaterial.color = try .init(texture: .init(.load(named: "Box_Texture")))
            let cubeEntity = ModelEntity(mesh: cubeMesh, materials: [cubeMaterial])
            cubeEntity.generateCollisionShapes(recursive: false)
            planeAnchor.addChild(cubeEntity)
            self.scene.addAnchor(planeAnchor)
            self.installGestures(.all, for: cubeEntity)
        } catch {
            print("找不到文件")
        }
    }
    
    func snapShotAR(){
        //方法一
         arView.snapshot(saveToHDR: false){(image) in
             UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.imageSaveHandler(image:didFinishSavingWithError:contextInfo:)), nil)
         }
        
//        方法二
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
//        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
//        let uiImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        UIImageWriteToSavedPhotosAlbum(uiImage!, self, #selector(imageSaveHandler(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    func snapShotCamera(){
        guard let pixelBuffer = arView.session.currentFrame?.capturedImage else {
            return
        }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer),
        context = CIContext(options: nil),
        cgImage = context.createCGImage(ciImage, from: ciImage.extent),
        uiImage = UIImage(cgImage: cgImage!, scale: 1, orientation: .right)
        UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(imageSaveHandler(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func imageSaveHandler(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil {
            print("保存图片出错")
        } else {
            print("保存图片成功")
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

