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
    var playerItem1: AVPlayerItem!
    var playerItem2: AVPlayerItem!
    var player: AVQueuePlayer!
    var playerLayer: AVPlayerLayer?
    var playerObservation: NSKeyValueObservation?
    
    func setObserver() {
        playerObservation = playerItem1.observe(\.status, options: .new, changeHandler: { item, value in
            if item.status == .readyToPlay {
                self.player.play()
            }
        })
    }
}

@Observable class ApplicationData {
    var playing: Bool = false
    var progress: CGFloat = 0
    @ObservationIgnored var customVideoView: PlayerView!
    @ObservationIgnored var viewData: ViewData
    
    init() {
        customVideoView = PlayerView()
        viewData = ViewData()
        
        let bundle = Bundle.main
        let videoURL1 = bundle.url(forResource: "videotrees", withExtension: "mp4")
        let videoURL2 = bundle.url(forResource: "videobeaches", withExtension: "mp4")
        
        let asset1 = AVURLAsset(url: videoURL1!)
        let asset2 = AVURLAsset(url: videoURL2!)
        viewData.playerItem1 = AVPlayerItem(asset: asset1)
        viewData.playerItem2 = AVPlayerItem(asset: asset2)
        viewData.player = AVQueuePlayer(items: [viewData.playerItem1, viewData.playerItem2])
        
        viewData.playerLayer = customVideoView.view.layer as? AVPlayerLayer
        viewData.playerLayer?.player = viewData.player
       
        viewData.setObserver()
    }
}
