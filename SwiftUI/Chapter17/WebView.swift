//
//  WebView.swift
//  Test
//
//  Created by Alan on 2023/11/8.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let searchURL: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        let request = URLRequest(url: searchURL)
        view.load(request)
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
