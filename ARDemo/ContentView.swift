//
//  ContentView.swift
//  ARDemo
//
//  Created by Alan on 8/8/23.
//

import SwiftUI
import RealityKit
import ARKit
import VideoToolbox
import Combine

struct ContentView : View {
    var body: some View {
        ARViewContainer()
            .overlay(
                VStack{
                    Spacer()
                    Button(action: {arView.catchHuman()}){
                        Text("截取人形")
                            .frame(width:120,height:40)
                            .font(.body)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .opacity(0.6)
                    }
                    .offset(y:-30)
                    .padding(.bottom, 30)
                }
            ).edgesIgnoringSafeArea(.all)
    }
}

var arView : ARView!

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        arView = ARView(frame: .zero)
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(ARConfiguration.FrameSemantics.personSegmentationWithDepth) else {
            fatalError("当前设备不支持人形遮挡")
        }
        let config = ARBodyTrackingConfiguration()
        config.frameSemantics = .personSegmentationWithDepth
        arView.session.delegate = arView
        arView.session.run(config)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

var arFrame : ARFrame!
extension ARView : ARSessionDelegate{
    public  func session(_ session: ARSession, didUpdate frame: ARFrame) {
        arFrame = frame
    }
    func catchHuman(){
        if let segmentationBuffer = arFrame.segmentationBuffer {
            if let uiImage = UIImage(pixelBuffer: segmentationBuffer)?.rotate(radians: .pi / 2) {
                UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(imageSaveHandler(image:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    @objc func imageSaveHandler(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil {
            print("保存图片出错")
        } else {
            print("保存图片成功")
        }
    }
}

extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
    
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        return self
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
