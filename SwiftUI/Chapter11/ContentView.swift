//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.red, lineWidth: 20)
                .frame(width: 100, height: 100)
                .padding()
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(Color.red, lineWidth: 20)
                .frame(width: 100, height: 100)
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
