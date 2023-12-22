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
            HeaderView(title: $title, titleInput: $titleInput)
            Button(action: {
                title = titleInput
                titleInput = ""
            }, label: {
                Text("Change Title")
            })
            Spacer()
        }.padding()
    }
}

struct HeaderView: View {
    @Binding var title: String
    @Binding var titleInput: String
    let counter: Int
    
    init(title: Binding<String>, titleInput: Binding<String>) {
        _title = title
        _titleInput = titleInput
        
        let sentence = _title.wrappedValue
        counter = sentence.count
    }
    
    var body: some View {
        VStack {
            Text("\(title) (\(counter))")
                .padding(10)
            TextField("Inserted Title", text: $titleInput)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    ContentView()
}

#Preview("Header") {
    let constantTitle = Binding<String>(
        get: { return "My Preview Title" },
        set: { value in
            print(value)
        })
    let constantInput = Binding<String>(
        get: { return "" },
        set: { value in
            print(value)
        })
    return HeaderView(title: constantTitle, titleInput: constantInput)
}
