//
//  ShowImage.swift
//  Test
//
//  Created by Alan on 2023/12/5.
//

import SwiftUI

struct ShowImage: View {
    var body: some View {
        Image(.spot1)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ShowImage()
}
