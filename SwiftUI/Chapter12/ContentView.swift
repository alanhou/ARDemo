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
    
    var body: some View {
        Image(.spot1)
            .resizable()
            .scaledToFit()
            .frame(width: 160, height: 200)
            .onTapGesture { location in
                expand = true
                print("Location: \(location)")
            }
            .sheet(isPresented: $expand) {
                ShowImage()
            }
    }
}

#Preview {
    ContentView()
}
