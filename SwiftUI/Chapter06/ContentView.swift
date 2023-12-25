//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var showInfo = false
    
    var body: some View {
        VStack(spacing: 10) {
            Button("Show Information") {
                showInfo.toggle()
            }.padding()
            if showInfo {
                Text("This is the information")
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
