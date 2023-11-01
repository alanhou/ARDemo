//
//  TapMakesCup.swift
//  Tap Makes Cup
//
//  Created by Alan on 2023/11/1.
//

import Foundation
import SwiftUI

@main
struct TapMakesCupApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene{
        WindowGroup{
            ContentView()
                .environmentObject(viewModel)
                .onChange(of: scenePhase){ newPhase in
                    switch newPhase {
                    case .active:
                        print("App did become active")
                        viewModel.resume()
                    case .inactive:
                        print("App did become inactive")
                    default:
                        break
                    }
                }
        }
    }
}
