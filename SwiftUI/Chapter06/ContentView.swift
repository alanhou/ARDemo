//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var pass: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text(pass)
                .padding()
            SecureField("Insert Password", text: $pass)
                .textFieldStyle(.roundedBorder)
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
