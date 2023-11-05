//
//  MyViewController.swift
//  Test
//
//  Created by Alan on 2023/11/5.
//

import SwiftUI

struct MyViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DetailViewController {
        let controller = DetailViewController()
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
