//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @Environment(ApplicationData.self) private var appData
    @State private var currentPicture: UIImage = UIImage(named: "nopicture")!
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(appData.listPictures) { picture in
                    Image(uiImage: UIImage(data: picture.image) ?? UIImage(named: "nopicture")!)
                        .resizable()
                        .frame(width: 80, height: 100)
                        .draggable(picture)
                }
            }.frame(height: 120)
            Image(uiImage: currentPicture)
                .resizable()
                .scaledToFit()
                .dropDestination(for: PictureRepresentation.self, action: { elements, location in
                    if let picture = elements.first {
                        currentPicture = UIImage(data: picture.image) ?? UIImage(named: "nopicture")!
                        appData.listPictures.removeAll(where: { $0.id == picture.id })
                        return true
                    }
                    return false
                })
            Spacer()
        }
    }
}

#Preview {
    ContentView().environment(ApplicationData())
}
