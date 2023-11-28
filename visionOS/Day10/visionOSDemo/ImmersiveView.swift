//
//  ImmersiveView.swift
//  visionOSDemo
//
//  Created by Alan on 2023/11/28.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @State var model = ViewModel()
    
    var body: some View {
        RealityView { content in
            content.add(model.setupContentEntity())
        }
        .onTapGesture {
            model.toggleSorted()
        }
    }
}


#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
