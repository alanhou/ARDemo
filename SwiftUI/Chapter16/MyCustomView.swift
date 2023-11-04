//
//  MyCustomView.swift
//  Test
//
//  Created by Alan on 2023/11/4.
//

import SwiftUI

struct MyCustomView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = UIColor(.blue)
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
