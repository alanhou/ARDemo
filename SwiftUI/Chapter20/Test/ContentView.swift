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
            MyView(mytext: "Hello World!")
            Spacer()
        }
    }
}

struct MyView: View {
    let mytext: LocalizedStringResource
    
    var body: some View {
        Text(mytext)
            .padding()
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
