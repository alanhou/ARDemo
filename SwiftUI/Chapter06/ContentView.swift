//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var title: String = "Default Title"
    @State private var isValid: Bool = true
    var body: some View {
        VStack {
            Text(title)
                .padding(10)
            Button(action: {
                isValid.toggle()
                title = isValid ? "Valid" : "Invalid"
            }, label: {
                Text("Change Validation")
            })
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
