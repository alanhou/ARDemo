//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        Image(.spot1)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 200)
            .offset(CGSize(width: 75, height: 0))
    }
}

#Preview {
    ContentView()
}
