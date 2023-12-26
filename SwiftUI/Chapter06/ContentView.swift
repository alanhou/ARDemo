//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button("Cancel") {
                    print("Cancel Action")
                }.buttonStyle(.bordered)
                Spacer()
                Button("Send") {
                    print("Send Information")
                }.buttonStyle(.borderedProminent)
            }
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
