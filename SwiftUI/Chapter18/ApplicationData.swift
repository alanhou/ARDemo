//
//  ApplicatonData.swift
//  Test
//
//  Created by Alan on 2023/11/27.
//

import SwiftUI
import Observation
import AVFoundation

class ViewData: NSObject {
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playerObservation: NSKeyValueObservation?
    
    func setObserver() {
        playerObservation = playerItem?.observe(\.status, options: .new, changeHandler: { item, value in
            if item.status == .readyToPlay {
                self.player?.play()
            }
        })
    }
}

@Observable class ApplicationData {
    @ObservationIgnored var customVideoView: PlayerView!
    @ObservationIgnored var viewData: ViewData
    
    init() {
        customVideoView = PlayerView()
        viewData = ViewData()
        
        let bundle = Bundle.main
        let videoURL = bundle.url(forResource: "videotrees", withExtension: "mp4")
        let asset = AVURLAsset(url: videoURL!)
        viewData.playerItem = AVPlayerItem(asset: asset)
        viewData.player = AVPlayer(playerItem: viewData.playerItem)
        
        viewData.playerLayer = customVideoView.view.layer as? AVPlayerLayer
        viewData.playerLayer?.player = viewData.player
        viewData.setObserver()
    }
}
