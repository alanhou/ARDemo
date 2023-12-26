//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

struct ContentView: View {
    @State private var expanded: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Default Title")
                .frame(minWidth: 0, maxWidth: expanded ? .infinity : 150, maxHeight: 50)
                .background(Color.yellow)
            Button(action: {
                expanded.toggle()
            }, label: {
                VStack {
                    Image(expanded ? .contract : .expand)
                        .renderingMode(.template)
                    Text(expanded ? "Contract" : "Expand")
                }
            })
            Spacer()
        }.padding()
    }
}

#Preview {
    ContentView()
}
