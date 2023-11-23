//
//  ViewModel.swift
//  visionOSDemo
//
//  Created by Alan on 2023/11/21.
//

import SwiftUI
import RealityKit

class ViewModel: ObservableObject {
    private var contentEntity = Entity()
    private let colors: [SimpleMaterial.Color] = [.gray, .red, .orange, .yellow, .green, .blue, .purple, .systemPink]
    
    func setupContentEntity() -> Entity {
        return contentEntity
    }
    
    func addCube() -> Entity {
        let entity = ModelEntity(
            mesh: .generateBox(size: 0.5, cornerRadius: 0),
            materials: [SimpleMaterial(color: .red, isMetallic: false)],
            collisionShape: .generateBox(size: SIMD3<Float>(repeating: 0.5)),
            mass: 0.0
        )
        
        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
        entity.position = SIMD3(x: 0, y: 1, z: -2)
        
        contentEntity.addChild(entity)
        
        return entity
    }
    
    func changeToRandomColor(entity: Entity) {
        guard let _entity = entity as? ModelEntity else { return }
        _entity.model?.materials = [SimpleMaterial(color: colors.randomElement()!, isMetallic: false)]
    }
}
