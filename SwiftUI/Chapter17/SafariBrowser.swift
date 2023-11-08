//
//  File.swift
//  Test
//
//  Created by Alan on 2023/11/8.
//

import SwiftUI
import SafariServices

struct SafariBrowser: UIViewControllerRepresentable {
    @Binding var searchURL: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safari = SFSafariViewController(url: searchURL)
        safari.dismissButtonStyle = .close
        safari.preferredBarTintColor = UIColor(red: 81/255, green: 91/255, blue: 119/255, alpha: 1.0)
        safari.preferredControlTintColor = UIColor.white
        return safari
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}
