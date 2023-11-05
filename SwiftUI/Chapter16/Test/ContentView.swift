//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Open UIKit View", destination: {
                    MyViewController()
                }).buttonStyle(.borderedProminent)
                Spacer()
            }.padding()
        }
    }
}

#Preview {
    ContentView()
}
