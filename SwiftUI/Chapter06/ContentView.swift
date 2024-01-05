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
    @Environment(\.colorScheme) var colorScheme
    @FocusState var focusName: FocusName?
    @State private var title: String = "Default Name"
    @State private var nameInput: String = ""
    @State private var surnameInput: String = ""
    
    var body: some View {
        let color: Color = colorScheme == .dark ? .black : .white
        VStack(spacing: 10) {
            Text(title)
                .lineLimit(1)
                .padding()
                .background(Color.yellow)
            TextField("Insert Name", text: $nameInput)
                .textFieldStyle(.roundedBorder)
                .padding(4)
                .background(focusName == .name ? Color(white: 0.9) : color)
                .focused($focusName, equals: .name)
            TextField("Insert Surname", text: $surnameInput)
                .textFieldStyle(.roundedBorder)
                .padding(4)
                .background(focusName == .surname ? Color(white: 0.9) : color)
                .focused($focusName, equals: .surname)
            HStack {
                Spacer()
                Button("Save") {
                    let tempName = nameInput.trimmingCharacters(in: .whitespaces)
                    let tempSurname = surnameInput.trimmingCharacters(in: .whitespaces)
                    
                    if !tempName.isEmpty && !tempSurname.isEmpty {
                        title = nameInput + " " + surnameInput
                        focusName = nil
                    }
                }
            }
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
