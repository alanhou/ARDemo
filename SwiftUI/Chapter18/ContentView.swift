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
        ZStack {
            appData.customVideoView
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
        .environment(ApplicationData())
}
