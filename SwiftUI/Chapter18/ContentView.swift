//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @Environment(ApplicationData.self) private var appData
    
    var body: some View {
        NavigationStack(path: Bindable(appData).path) {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink("Take Picture", value: "Open Camera")
                }.navigationDestination(for: String.self, destination: { _ in
                    CustomCameraView()
                })
                Image(uiImage: appData.picture ?? UIImage(named: "nopicture")!)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                Spacer()
            }.padding()
                .navigationBarHidden(true)
        }.statusBarHidden()
    }
}

#Preview {
    ContentView()
        .environment(ApplicationData())
}
