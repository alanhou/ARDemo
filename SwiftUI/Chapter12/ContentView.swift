//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(.husky)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 400)
                .draggable(Image(.husky))
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
