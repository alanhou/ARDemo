//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selected: PhotosPickerItem?
    @State private var picture: UIImage?
    var body: some View {
        NavigationStack {
            VStack {
                Image(uiImage: picture ?? UIImage(named: "nopicture")!)
                    .resizable()
                    .scaledToFit()
                Spacer()
                PhotosPicker(selection: $selected, matching: .images, photoLibrary: .shared()) {
                    Text("Select a photo")}
                    .buttonStyle(.borderedProminent)
                    .photosPickerStyle(.inline)
                    .frame(height: 300)
                .onChange(of: selected, initial: false) { old, item in
                    Task(priority: .background) {
                        if let data = try? await item?.loadTransferable(type: Data.self) {
                            picture = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
