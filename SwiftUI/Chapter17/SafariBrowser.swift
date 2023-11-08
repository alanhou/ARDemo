//
//  File.swift
//  Test
//
//  Created by Alan on 2023/11/8.
//

import SwiftUI
import SafariServices

struct SafariBrowser: UIViewControllerRepresentable {
    @Binding var disable: Bool
    @Binding var searchURL: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = false
        let safari = SFSafariViewController(url: searchURL, configuration: config)
        safari.delegate = context.coordinator
        return safari
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
    func makeCoordinator() -> SafariCoordinator {
        SafariCoordinator(disableCoordinator: $disable)
    }
}

class SafariCoordinator: NSObject, SFSafariViewControllerDelegate {
    @Binding var disableCoordinator: Bool
    
    init(disableCoordinator: Binding<Bool>) {
        self._disableCoordinator = disableCoordinator
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        disableCoordinator = true
    }
}
