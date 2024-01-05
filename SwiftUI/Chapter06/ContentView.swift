//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

enum FocusName: Hashable {
    case name
    case surname
}

struct ContentView: View {
    @State private var text: String = ""
    
    var body: some View {
        TextField("Insert Text", text: $text, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .padding(20)
            .lineLimit(5)
    }
}

#Preview {
    ContentView()
}
