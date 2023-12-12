//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @GestureState private var pressing: Bool = false
    @State private var expand: Bool = false
    
    var body: some View {
        Image(.spot1)
            .resizable()
            .scaledToFit()
            .frame(width: 160, height: 200)
            .opacity(pressing ? 0 : 1)
            .gesture(
                LongPressGesture(minimumDuration: 1)
                    .updating($pressing) { value, state, transaction in
                        state = value
                        transaction.animation = Animation.easeInOut(duration: 1.5)
                    }
                    .onEnded { value in
                        expand = true
                    }
            )
            .sheet(isPresented: $expand) {
                ShowImage()
            }
    }
}

#Preview {
    ContentView()
}
