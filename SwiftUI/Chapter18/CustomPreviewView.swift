//
//  CustomPreviewView.swift
//  Test
//
//  Created by Alan on 2023/11/26.
//

import SwiftUI
import AVFoundation

class CustomPreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
struct CustomPreview: UIViewRepresentable {
    let view = CustomPreviewView()
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
