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
    
    let guides = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
            VStack {
                ScrollView {
                    LazyVGrid(columns: guides) {
                        ForEach(appData.listPictures) { item in
                            Image(uiImage: item.image)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
                .padding()
                Spacer()
                PhotosPicker(selection: Bindable(appData).selected, maxSelectionCount: 4, selectionBehavior: .continuous, matching: .images, photoLibrary: .shared()) {
                    Text("Select Photos")
                }
                .photosPickerStyle(.inline)
                .photosPickerDisabledCapabilities(.selectionActions)
            }
            .onChange(of: appData.selected, initial: false) { old, items in
                appData.removeDeselectedItems()
                appData.addSelectedItems()
            }
    }
}

#Preview {
    ContentView()
        .environment(ApplicationData())
}
