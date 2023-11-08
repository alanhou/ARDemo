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
        return safari
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}
