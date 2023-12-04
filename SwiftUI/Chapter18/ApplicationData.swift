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
        let videoURL = bundle.url(forResource: "videotrees", withExtension: "mp4")
        let asset = AVURLAsset(url: videoURL!)
        viewData.playerItem = AVPlayerItem(asset: asset)
        viewData.player = AVPlayer(playerItem: viewData.playerItem)
        
        viewData.playerLayer = customVideoView.view.layer as? AVPlayerLayer
        viewData.playerLayer?.player = viewData.player
       
        let interval = CMTime(value: 1, timescale: 2)
        viewData.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { time in
            if let duration = self.viewData.playerItem?.duration {
                let position = time.seconds / duration.seconds
                self.progress = CGFloat(position)
            }
        })
    }
    func playVideo() {
        if viewData.playerItem?.status == .readyToPlay {
            if playing {
                viewData.player?.pause()
                playing = false
            } else {
                viewData.player?.play()
                playing = true
            }
        }
    }
}
