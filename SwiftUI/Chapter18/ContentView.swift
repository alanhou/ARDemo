//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @Environment(ApplicationData.self) private var appData
    
    var body: some View {
        if appData.player != nil {
            VideoPlayer(player: appData.player)
                .ignoresSafeArea()
        } else {
            Text("Video not available")
        }
    }
}

#Preview {
    ContentView()
        .environment(ApplicationData())
}
