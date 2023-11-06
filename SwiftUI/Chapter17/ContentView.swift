//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var searchURL = "https://alanhou.org"
    
    var body: some View {
        NavigationStack {
            VStack {
                Link("Open Web", destination: URL(string: searchURL)!)
                    .buttonStyle(.borderedProminent)
                Spacer()
            }.padding()
        }
    }
}

#Preview {
    ContentView()
}
