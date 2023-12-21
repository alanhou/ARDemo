//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var title: String = "Default Title"
    @State private var titleInput: String = ""
    var body: some View {
        VStack {
            Text(_title.wrappedValue)
                .padding(10)
            TextField("Inserted Title", text: _titleInput.projectedValue)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                _title.wrappedValue = _titleInput.wrappedValue
                _titleInput.wrappedValue = ""
            }, label: {
                Text("Change Title")
            })
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
