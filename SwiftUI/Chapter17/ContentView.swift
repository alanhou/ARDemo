//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WebView(searchURL: URL(string: "https://www.google.com")!)
    }
}

#Preview {
    ContentView()
}
