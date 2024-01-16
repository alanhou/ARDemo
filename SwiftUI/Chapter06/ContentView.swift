//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
   var appData = ApplicationData()
    
    var body: some View {
        VStack(spacing: 8) {
            Text(appData.title)
                .padding(10)
            Button(action: {
                appData.title = "New Title"
            }, label: {
                Text("Save")
            })
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
