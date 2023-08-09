//
//  ContentView.swift
//  ARDemo
//
//  Created by Alan on 8/8/23.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.automaticallyConfigureSession = false
        let config = ARWorldTrackingConfiguration()
        if(ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification)){
            config.sceneReconstruction = .meshWithClassification
        }
        config.planeDetection = .horizontal
//        arView.ARSCNDebugOptions.insert(.showSceneUnderstanding)
        arView.session.run(config, options: [])
        arView.setupGestures()
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView {
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil){
        guard let touchInView = sender?.location(in: self) else {
            return
        }
//        方法一
        guard let raycastQuery = self.makeRaycastQuery(from: touchInView, allowing: .existingPlaneInfinite, alignment: .horizontal) else {
            return
        }
        guard let result = self.session.raycast(raycastQuery).first else { return }
//        方法二
//        guard let result = self.raycast(from: touchInView, allowing: .estimatedPlane, alignment: .any).first else{
//            return
//        }
        let transformation = Transform(matrix: result.worldTransform)
        let box = CustomEntity(color: .yellow, position: transformation.translation)
        self.installGestures(.all, for: box)
        box.addCollisions(scene: self.scene)
        self.scene.addAnchor(box)
    }
}
//自定义实体类
class CustomEntity: Entity, HasModel, HasAnchoring, HasCollision {
    var subscribes: [Cancellable] = []
    required init(color: UIColor) {
        super.init()
        self.components[CollisionComponent.self] = CollisionComponent(
            shapes: [.generateBox(size: [0.1,0.1,0.1])],
            mode: .default,
            filter: CollisionFilter(group: CollisionGroup(rawValue: 1), mask: CollisionGroup(rawValue: 1))
        )
        self.components[ModelComponent.self] = ModelComponent(
            mesh: .generateBox(size: [0.1,0.1,0.1]),
            materials: [SimpleMaterial(color: color, isMetallic: false)]
        )
    }
    
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color)
        self.position = position
    }
    
    required init() {
        fatalError("init()没有执行，初始化不成功")
    }
    
    func addCollisions(scene: RealityKit.Scene) {
        subscribes.append(scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
            guard let box = event.entityA as? CustomEntity else {
                return
            }
            box.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
        })
        subscribes.append(scene.subscribe(to: CollisionEvents.Ended.self, on: self){ event in
            guard let box = event.entityA as? CustomEntity else {
                return
            }
            box.model?.materials = [SimpleMaterial(color: .yellow, isMetallic: false)]
        })
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

