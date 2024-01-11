//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    
    var body: some View {
        TextEditor(text: $text)
            .multilineTextAlignment(.leading)
            .lineSpacing(10)
            .autocorrectionDisabled(true)
            .padding(8)
    }
}

#Preview {
    ContentView()
}
