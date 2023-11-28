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
            VideoPlayer(player: appData.player, videoOverlay: {
                VStack {
                    Text("Title: Trees at the park")
                        .font(.title)
                        .padding([.top, .bottom], 8)
                        .padding([.leading, .trailing], 16)
                        .foregroundColor(.black)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .padding(.top, 8)
                    Spacer()
                }
            })
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
