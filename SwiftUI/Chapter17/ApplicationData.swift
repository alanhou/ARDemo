//
//  ApplicationData.swift
//  Test
//
//  Created by Alan on 2023/11/9.
//

import SwiftUI
import Observation

struct Post: Codable, Identifiable {
    var id: Int
    var userId: Int
    var title: String
    var body: String
}

@Observable class ApplicationData {
    var listOfPosts: [Post] = []
    
    init() {
        Task(priority: .high) {
            await loadJSON()
        }
    }
    func loadJSON() async {
        let session = URLSession.shared
        let webURL = URL(string: "https://jsonplaceholder.typicode.com/posts")
        
        do {
            let (data, response) = try await session.data(from: webURL!)
            if let resp = response as? HTTPURLResponse {
                let status = resp.statusCode
                if status == 200 {
                    let decoder = JSONDecoder()
                    if let posts = try? decoder.decode([Post].self, from: data) {
                        await MainActor.run {
                            listOfPosts = posts
                        }
                    }
                } else {
                    print("Error: \(status)")
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
