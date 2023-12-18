//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var title: String = "Default Title"
    var body: some View {
        VStack {
            Text(title)
                .padding(10)
            Button(action: {
                title = "My New Title"
            }, label: {
                Text("Change Title")
            })
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
