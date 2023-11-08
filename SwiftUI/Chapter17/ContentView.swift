//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var webView: WebView!
    @State private var inputURL: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Insert URL", text: $inputURL)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                Button("Load") {
                    let text = inputURL.trimmingCharacters(in: .whitespaces)
                    if !text.isEmpty {
                        webView.loadWeb(web: text)
                    }
                }
            }.padding(5)
            webView
        }.onAppear {
            webView = WebView(inputURL: $inputURL)
        }
    }
}

#Preview {
    ContentView()
}
