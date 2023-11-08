//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var searchURL: URL = URL(string: "https://www.formasterminds.com")!
    @State private var openSheet: Bool = false
    
    var body: some View {
        VStack {
            Button("Open Browser") {
                openSheet = true
            }.buttonStyle(.borderedProminent)
            Spacer()
        }.padding()
            .sheet(isPresented: $openSheet) {
                SafariBrowser(searchURL: $searchURL)
            }
    }
}

#Preview {
    ContentView()
}
