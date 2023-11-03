//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var mytext = String(localized: "Hello World!")
    var body: some View {
        VStack {
            Text(mytext)
                .padding()
            Button("Change Text") {
                mytext = String(localized: "Goodbye World!")
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
#Preview {
    ContentView()
        .environment(\.locale, Locale(identifier: "es"))
}
#Preview {
    ContentView()
        .environment(\.locale, Locale(identifier: "zh"))
        .environment(\.layoutDirection, .leftToRight)
}
