//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @Environment(ApplicationData.self) private var appData
    
    var body: some View {
        VStack {
            Button("Load Web") {
                Task(priority: .high) {
                    await appData.loadWeb()
                }
            }.disabled(appData.buttonDisabled)
            
            Text("Total Characters: \(appData.webContent.count)")
                .padding()
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView().environment(ApplicationData())
}
