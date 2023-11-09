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
    @Binding var backDisabled: Bool
    @Binding var forwardDisabled: Bool
    
    let view: WKWebView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        view.navigationDelegate = context.coordinator
        let request = URLRequest(url: URL(string: "https://www.google.com")!)
        self.view.load(request)
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
    func goBack() {
        view.goBack()
    }
    func goForward() {
        view.goForward()
    }
    func refresh() {
        view.reload()
    }
    func makeCoordinator() -> CoordinatorWebView {
        return CoordinatorWebView(input: $inputURL, back: $backDisabled, forward: $forwardDisabled)
    }
}

class CoordinatorWebView: NSObject, WKNavigationDelegate {
    @Binding var inputURL: String
    @Binding var backDisabled: Bool
    @Binding var forwardDisabled: Bool
    
    init(input: Binding<String>, back: Binding<Bool>, forward: Binding<Bool>) {
        self._inputURL = input
        self._backDisabled = back
        self._forwardDisabled = forward
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let webURL = webView.url {
            inputURL = webURL.absoluteString
            backDisabled = !webView.canGoBack
            forwardDisabled = !webView.canGoForward
        }
    }
}
