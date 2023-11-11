//
//  ContentView.swift
//  Test
//
//  Created by Alan on 2023/11/2.
//

import SwiftUI

actor ItemData {
    var counter: Int = 0
    
    func incrementCount() -> String {
        counter += 1
        return "Value: \(counter)"
    }
}
struct ContentView: View {
    var item: ItemData = ItemData()
    
    var body: some View {
        Button("Start Process") {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
                Task(priority: .background) {
                    async let operation = item.incrementCount()
                    print(await operation)
                }
            }
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
                Task(priority: .high) {
                    async let operation = item.incrementCount()
                    print(await operation)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
