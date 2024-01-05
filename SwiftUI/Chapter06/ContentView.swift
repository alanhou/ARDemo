//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

enum FocusName: Hashable {
    case name
    case surname
}

struct ContentView: View {
    @State private var title: String = "Default Name"
    @State private var numberInput = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .padding()
                .background(Color.yellow)
            TextField("Insert Number", text: $numberInput)
                .textFieldStyle(.roundedBorder)
                .padding(4)
                .keyboardType(.numbersAndPunctuation)
                .onChange(of: numberInput, initial: false) { old, value in
                    if !value.isEmpty && Int(value) == nil {
                        numberInput = old
                    }
                }
            HStack {
                Spacer()
                Button("Save") {
                    title = numberInput
                    numberInput = ""
                }
            }
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
