//
//  ApplicatonData.swift
//  Test
//
//  Created by Alan on 2023/11/27.
//

import SwiftUI
import Observation
import AVKit

@Observable class ApplicationData {
    var player: AVPlayer!
    
    init() {
        let bundle = Bundle.main
        if let videoURL = bundle.url(forResource: "videotrees", withExtension: "mp4") {
            player = AVPlayer(url: videoURL)
        }
    }
}
