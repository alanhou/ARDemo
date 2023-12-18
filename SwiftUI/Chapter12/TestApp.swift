//
//  TestApp.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

@main
struct TestApp: App {
    @State private var appData = ApplicationData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appData)
        }
    }
}
