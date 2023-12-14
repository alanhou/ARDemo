//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var picture: Image = Image(.nopicture)
    var body: some View {
        VStack {
            picture
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 400)
                .dropDestination(for: Image.self, action: { elements, location in
                    if let image = elements.first {
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
