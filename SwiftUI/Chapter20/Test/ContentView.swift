//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello World!", comment: "This is a welcome message")
                .padding()
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
