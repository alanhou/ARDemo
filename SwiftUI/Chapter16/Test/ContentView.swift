//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText: String = "Initial text"
    var body: some View {
        VStack {
            HStack {
                Text(inputText)
                Spacer()
                Button("Clear") {
                    inputText = ""
                }
            }
            TextView(input: $inputText)
        }.padding()
    }
}

#Preview {
    ContentView()
}
