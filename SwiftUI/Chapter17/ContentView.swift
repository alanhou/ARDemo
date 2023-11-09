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
    @State private var backDisabled: Bool = true
    @State private var forwardDisabled: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                TextField("Insert URL", text: $inputURL)
                Button("Load") {
                    let text = inputURL.trimmingCharacters(in: .whitespaces)
                    if !text.isEmpty {
                        webView.loadWeb(web: text)
                    }
                }
            }.padding(5)
            
            HStack {
                Button(action: {
                    webView.goBack()
                }, label: {
                    Image(systemName: "arrow.left.circle")
                        .font(.title)
                }).disabled(backDisabled)
                Button(action: {
                    webView.goForward()
                }, label: {
                    Image(systemName: "arrow.right.circle")
                        .font(.title)
                }).disabled(forwardDisabled)
                Spacer()
                Button(action: {
                    webView.refresh()
                }, label: {
                    Image(systemName: "arrow.clockwise.circle")
                        .font(.title)
                })
            }.padding(5)
            webView
        }.onAppear {
            webView = WebView(inputURL: $inputURL, backDisabled: $backDisabled, forwardDisabled: $forwardDisabled)
        }
    }
}

#Preview {
    ContentView()
}
