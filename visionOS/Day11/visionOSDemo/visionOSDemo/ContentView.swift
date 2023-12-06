//
//  ContentView.swift
//  visionOSDemo
//
//  Created by Alan on 2023/11/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(ViewModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        
        NavigationStack {
            VStack {
                Spacer()
                VStack {
                    Text(model.finalTitle)
                        .monospaced()
                        .font(.system(size: 50, weight: .bold))
                        .padding(.horizontal, 40)
                        .hidden()
                        .overlay(alignment: .leading) {
                            Text(model.titleText)
                                .monospaced()
                                .font(.system(size: 50, weight: .bold))
                                .padding(.leading, 40)
                        }
                    Text("林黛玉进贾府")
                        .font(.title)
                        .padding(.top, 10)
                        .opacity(model.isTitleFinished ? 1 : 0)
                }
                Spacer()
            }
            .typeText(text: $model.titleText, finalText: model.finalTitle, isFinished: $model.isTitleFinished, isAnimated: !model.isTitleFinished)
        }
    }
}

#Preview {
    ContentView()
        .environment(ViewModel())
}
