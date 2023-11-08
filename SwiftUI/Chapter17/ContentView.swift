//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) var openURL
    @State private var searchURL = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Insert URL", text: $searchURL)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                Button("Open Web") {
                    if !searchURL.isEmpty {
                        var components = URLComponents(string: searchURL)
                        components?.scheme = "https"
                        if let newURL = components?.string {
                            if let url = newURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                                openURL(URL(string: url)!)
                            }
                        }
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
