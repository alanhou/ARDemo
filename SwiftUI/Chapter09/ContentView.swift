//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

actor ItemData {
    var counter: Int = 0
    let maximum: Int = 30
    
    func incrementCount() -> String {
        counter += 1
        return "Value: \(counter)"
    }
    nonisolated func maximumValue() -> String {
        return "Maximum Value: \(maximum)"
    }
}
struct ContentView: View {
    var item: ItemData = ItemData()
    
    var body: some View {
        Button("Start Process") {
            let value = item.maximumValue()
            print(value)
        }
    }
}

#Preview {
    ContentView()
}
