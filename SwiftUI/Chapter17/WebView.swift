//
//  WebView.swift
//  Test
//
//  Created by Alan on 2023/11/8.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var inputURL: String
    let view: WKWebView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        view.navigationDelegate = context.coordinator
        let request = URLRequest(url: URL(string: "https://www.google.com")!)
        view.load(request)
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func loadWeb(web: String) {
        var components = URLComponents(string: web)
        components?.scheme = "https"
        if let newURL = components?.string {
            if let url = newURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let loadURL = URL(string: url) {
                    let request = URLRequest(url: loadURL)
                    view.load(request)
                }
            }
        }
    }
    func makeCoordinator() -> CoordinatorWebView {
        return CoordinatorWebView(input: $inputURL)
    }
}

class CoordinatorWebView: NSObject, WKNavigationDelegate {
    @Binding var inputURL: String
    
    init(input: Binding<String>) {
        self._inputURL = input
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let webURL = webView.url {
            inputURL = webURL.absoluteString
        }
    }
}
