//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var selectedColor: Color = .white
    
    var body: some View {
        VStack {
            ColorPicker("Select a Color", selection: $selectedColor)
                .padding()
            Spacer()
        }.background(selectedColor)
    }
}

#Preview {
    ContentView()
}
