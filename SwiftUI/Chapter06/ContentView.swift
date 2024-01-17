//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI
import Observation

@Observable class ViewData {
    var titleInput: String = ""
    @ObservationIgnored var counter: Int = 0
}

struct ContentView: View {
   @Bindable var viewData = ViewData()
    var appData = ApplicationData()
    
    var body: some View {
        VStack(spacing: 8) {
            Text(appData.title)
                .padding(10)
            TextField("Insert Title", text: $viewData.titleInput)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                appData.title = viewData.titleInput
                viewData.titleInput = ""
                viewData.counter += 1
                print("Current Counter: \(viewData.counter)")
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
