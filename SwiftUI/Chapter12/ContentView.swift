//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var picture: Image = Image(.nopicture)
    @State private var didEnter: Bool = false
    var body: some View {
        VStack {
            picture
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 400)
                .overlay(didEnter ? Color.green.opacity(0.2) : Color.clear)
                .dropDestination(for: Image.self, action: { elements, location in
                    if let image = elements.first {
                        picture = image
                        return true
                    }
                    return false
                }, isTargeted: { value in
                    didEnter = value
                })
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
