//
//  ApplicationData.swift
//  Test
//
//  Created by Alan on 2023/11/9.
//

import SwiftUI
import Observation

@Observable class ApplicationData: NSObject, URLSessionTaskDelegate {
    var webContent: String = ""
    var buttonDisabled: Bool = false
    
    func loadWeb() async {
        buttonDisabled = true
        
        let session = URLSession.shared
        
        let webURL = URL(string: "https://www.yahoo.com")
        do {
            let (data, response) = try await session.data(from: webURL!, delegate: self)
            if let resp = response as? HTTPURLResponse {
                let status = resp.statusCode
                if status == 200 {
                    if let content = String(data: data, encoding: String.Encoding.ascii) {
                        await MainActor.run {
                            webContent = content
                            buttonDisabled = false
                        }
                        print(content)
                    }
                } else {
                    print("Error: \(status)")
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest) async -> URLRequest? {
        print(request.url ?? "No URL")
        return request
    }
}
