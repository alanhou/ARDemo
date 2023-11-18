//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var picture: UIImage?
    
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink("Get Picture", value: "Open Picker")
                }.navigationDestination(for: String.self, destination: { _ in
                    ImagePicker(path: $path, picture: $picture)
                })
                Image(uiImage: picture ?? UIImage(named: "nopicture")!)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                Spacer()
            }.padding()
        }.statusBarHidden()
    }
}

#Preview {
    ContentView()
}
