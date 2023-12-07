//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var expand: Bool = false
    @State private var allowExpansion: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(.spot1)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 200)
                .onTapGesture {
                    expand = true
                }
                .allowsHitTesting(allowExpansion)
                .sheet(isPresented: $expand) {
                    ShowImage()
            }
            Toggle("", isOn: $allowExpansion)
                .labelsHidden()
        }
    }
}

#Preview {
    ContentView()
}
