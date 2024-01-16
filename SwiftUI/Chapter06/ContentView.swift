//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var currentValue: Float = 5
    
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
