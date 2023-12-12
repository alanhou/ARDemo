//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

enum PressingState {
    case active
    case inactive
    
    var isActive: Bool {
        switch self {
        case .active:
            return true
        case .inactive:
            return false
        }
    }
}

struct ContentView: View {
    @GestureState private var pressingState = PressingState.inactive
    @State private var expand: Bool = false
    
    var body: some View {
        Image(.spot1)
            .resizable()
            .scaledToFit()
            .frame(width: 160, height: 200)
            .opacity(pressingState.isActive ? 0 : 1)
            .gesture(
                LongPressGesture(minimumDuration: 1)
                    .updating($pressingState) { value, state, transaction in
                        state = value ? .active : .inactive
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
