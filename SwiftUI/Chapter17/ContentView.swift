//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @Environment(ApplicationData.self) private var appData
    
    var body: some View {
        VStack {
            List {
                ForEach(appData.listOfPosts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title).bold()
                        Text(post.body)
                    }.padding(5)
                }
            }.listStyle(.plain)
        }.padding()
    }
}

#Preview {
    ContentView().environment(ApplicationData())
}
