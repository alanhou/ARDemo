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
        MyInputView(appData: appData)
    }
}

struct MyInputView: View {
    @Bindable var appData: ApplicationData
    
    var body: some View {
        VStack(spacing: 8) {
            Text(appData.title)
                .padding(10)
            TextField("Insert Title", text: $appData.titleInput)
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
