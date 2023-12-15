//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ImageRepresentation: Transferable {
    let name: String
    let image: UIImage
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png, exporting: { value in
            return value.image.pngData()!
        })
    }
}
struct ContentView: View {
    @State private var picture: UIImage = UIImage(named: "nopicture")!
    var body: some View {
        VStack {
            Image(uiImage: picture)
                .resizable()
                .scaledToFit()
                .draggable(ImageRepresentation(name: "My Picture", image: picture))
                .dropDestination(for: Data.self, action: { elements, location in
                    if let data = elements.first, let image = UIImage(data: data) {
                        picture = image
                        return true
                    }
                    return false
                })
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
