//
//  ApplicationData.swift
//  Test
//
//  Created by Alan on 2023/12/18.
//

import SwiftUI
import Observation
import UniformTypeIdentifiers

struct PictureRepresentation: Identifiable, Codable, Transferable {
    var id = UUID()
    var image: Data
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: PictureRepresentation.self, contentType: .product)
    }
}

extension UTType {
    static var product = UTType(exportedAs: "org.alanhou.pictures")
}

@Observable class ApplicationData {
    var listPictures: [PictureRepresentation]
    
    init() {
        listPictures = [
            PictureRepresentation(image: UIImage(named: "spot1")!.pngData()!),
            PictureRepresentation(image: UIImage(named: "spot2")!.pngData()!),
            PictureRepresentation(image: UIImage(named: "spot3")!.pngData()!)
        ]
    }
}

