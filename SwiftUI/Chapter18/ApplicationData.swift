//
//  ApplicationData.swift
//  Test
//
//  Created by Alan on 2023/11/16.
//

import SwiftUI
import Observation
import PhotosUI

struct ItemsData: Identifiable {
    var id: String
    var image: UIImage
}
@Observable class ApplicationData {
    var listPictures: [ItemsData] = []
    var selected: [PhotosPickerItem] = []
    
    func removeDeselectedItems() {
        listPictures = listPictures.filter{ value in
            if selected.contains(where: { $0.itemIdentifier == value.id }) {
                return true
            } else {
                return false
            }
        }
    }
    func addSelectedItems() {
        for item in selected {
            Task(priority: .background) {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    if let id = item.itemIdentifier, let image = UIImage(data: data) {
                        if !listPictures.contains(where: { $0.id == id}) {
                            let newPicture = ItemsData(id: id, image: image)
                            await MainActor.run {
                                listPictures.append(newPicture)
                            }
                        }
                    }
                }
            }
        }
    }
}
