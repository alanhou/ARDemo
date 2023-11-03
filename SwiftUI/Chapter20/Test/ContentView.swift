//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var counter = 1
    var body: some View {
        VStack {
            Text("\(counter) Item")
                .padding()
            Button("Add Unit") {
                counter += 1
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
