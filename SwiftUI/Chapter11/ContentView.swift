//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    let gradient = Gradient(colors: [Color.red, Color.white])
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(.radialGradient(gradient, center: .center, startRadius: 0, endRadius: 120))
            .frame(width: 100, height: 100)
    }
}

#Preview {
    ContentView()
}
