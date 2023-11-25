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
                    if let picture = picture {
                        let photo = Image(uiImage: picture)
                        ShareLink("Share Picture", item: photo, preview: SharePreview("Photo", image: photo))
                    }
                    Spacer()
                    NavigationLink("Get Picture", value: "Open Picker")
                }.navigationDestination(for: String.self, destination: { _ in
                    ImagePicker(path: $path, picture: $picture)
                })
                Image(uiImage: picture ?? UIImage(named: "nopicture")!)
                    .resizable()
                    .scaledToFill()
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
