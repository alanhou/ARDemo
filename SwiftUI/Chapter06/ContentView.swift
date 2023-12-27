//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                print("Send information")
            }, label: {
                HStack {
                    Image(systemName: "mail")
                        .imageScale(.large)
                    Text("Send")
                }
            })
            .buttonStyle(.borderedProminent)
            .font(.largeTitle)
            .controlSize(.large)
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
