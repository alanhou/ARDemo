//
//  CustomPlayerView.swift
//  Test
//
//  Created by Alan on 2023/12/4.
//

import SwiftUI
import AVFoundation

class CustomPlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

struct PlayerView: UIViewRepresentable {
    var view = CustomPlayerView()
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
