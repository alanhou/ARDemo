//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) var openURL
    @State private var searchURL = "https://alanhou.org"
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Open Web") {
                    if let url = searchURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        openURL(URL(string: url)!)
                    }
                }
                    .buttonStyle(.borderedProminent)
                Spacer()
            }.padding()
        }
    }
}

#Preview {
    ContentView()
}
