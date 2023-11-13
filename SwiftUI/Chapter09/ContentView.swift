//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    let website = URL(string: "http://alanhou.org/homepage/wp-content/uploads/2019/03/201903251411121.jpg")
    var body: some View {
        VStack {
            AsyncImage(url: website)
        }.padding()
    }
}

#Preview {
    ContentView()
}
