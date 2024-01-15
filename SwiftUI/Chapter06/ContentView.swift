//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct MyStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            configuration.label
            Spacer()
            Image(systemName: "checkmark.rectangle.fill")
                .font(.largeTitle)
                .foregroundColor(configuration.isOn ? Color.green : Color.gray)
                .onTapGesture {
                    configuration.$isOn.wrappedValue.toggle()
                }
        }
    }
}

struct ContentView: View {
    @State private var currentState: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Toggle("Enabled", isOn: $currentState)
                .toggleStyle(MyStyle())
                Spacer()
            }.padding()
        }
    }
}

#Preview {
    ContentView()
}
