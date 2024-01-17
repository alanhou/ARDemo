//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI
import Observation

struct ContentView: View {
    @Environment(ApplicationData.self) private var appData
    
    var body: some View {
        VStack(spacing: 8) {
            Text(appData.title)
                .padding(10)
            TextField("Insert Title", text: Bindable(appData).titleInput)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                appData.title = appData.titleInput
                appData.titleInput = ""
            }, label: { Text("Save") })
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
        .environment(ApplicationData())
}
