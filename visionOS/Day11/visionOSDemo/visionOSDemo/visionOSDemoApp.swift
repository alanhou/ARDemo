//
//  visionOSDemoApp.swift
//  visionOSDemo
//
//  Created by Alan on 2023/11/20.
//

import SwiftUI

@main
struct visionOSDemoApp: App {
    @State private var model = ViewModel()
    var body: some Scene {
        WindowGroup() {
            ContentView()
                .environment(model)
        }
    }
}
