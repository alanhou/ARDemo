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
}

struct ContentView: View {
   @Bindable var viewData = ViewData()
    var appData = ApplicationData()
    
    init() {
        viewData.titleInput = appData.title
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(appData.title)
                .padding(10)
            TextField("Insert Title", text: $viewData.titleInput)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                appData.title = viewData.titleInput
                viewData.titleInput = ""
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
