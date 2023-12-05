//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var expand: Bool = false
    @State private var pressing: Bool = false
    
    var body: some View {
        Image(.spot1)
            .resizable()
            .scaledToFit()
            .frame(width: 160, height: 200)
            .opacity(pressing ? 0 : 1)
            .onLongPressGesture(minimumDuration: 1, maximumDistance: 10,perform: {
                expand = true
            }, onPressingChanged: { value in
                withAnimation(.easeInOut(duration: 1.5)) {
                    pressing = value
                }
            })
            .sheet(isPresented: $expand) {
                ShowImage()
            }
    }
}

#Preview {
    ContentView()
}
