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
            MyCustomView()
                .frame(width: 200, height: 150)
                .padding()
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
