//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @GestureState private var rotationAngle: Angle = Angle.zero
    @State private var rotation: Angle = Angle.zero
    
    var body: some View {
        Image(.spot1)
            .resizable()
            .scaledToFit()
            .frame(width: 160, height: 200)
            .rotationEffect(rotation + rotationAngle)
            .gesture(RotationGesture()
                .updating($rotationAngle) { value, state, transaction in
                    state = value
                }
                .onEnded { value in
                    rotation = rotation + value
                }
            )
    }
}

#Preview {
    ContentView()
}
