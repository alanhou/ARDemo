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
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack {
                    Button("Share Picture") {
                        showAlert = true
                    }.disabled(picture == nil ? true : false)
                    Spacer()
                    NavigationLink("Get Picture", value: "Open Picker")
                }.navigationDestination(for: String.self, destination: { _ in
                    ImagePicker(path: $path, picture: $picture)
                })
                .alert("Save Picture", isPresented: $showAlert, actions: {
                    Button("Cancel", role: .cancel, action: {
                        showAlert = false
                    })
                    Button("YES", role: .none, action: {
                        if let picture {
                            UIImageWriteToSavedPhotosAlbum(picture, nil, nil, nil)
                        }
                    })
                }, message: { Text("Do you want to store the picture in the Photo Library?") })
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
