//
//  VisualizationViewController.swift
//  ARKitDemo
//
//  Created by alan on 9/18/23.
//

import UIKit
import ARKit

final class VisualizationViewController: UIViewController{
    private let worldMap: ARWorldMap
    private let sceneView = SCNView()
    private let scene = SCNScene()
    private let cameraNode: SCNNode = {
       let cameraNode = SCNNode()
       cameraNode.camera = SCNCamera()
       cameraNode.position = SCNVector3(
          x: 0, y: 0, z: 10)
       return cameraNode
    }()
    private let omniLightNode: SCNNode = {
       let lightNode = SCNNode()
       lightNode.light = SCNLight()
       lightNode.light?.type = .omni
       lightNode.position = SCNVector3(
          x: 0, y: 10, z: 10)
       return lightNode
    }()
    private let sphereNode: SCNNode = {
       let sphere = SCNSphere(radius: 0.01)
       let material = SCNMaterial()
       material.metalness.contents = 0
       material.roughness.contents = 0
       material.lightingModel = .blinn
       sphere.firstMaterial?.diffuse.contents =
          UIColor.systemYellow
       let sphereNode = SCNNode(geometry: sphere)
       return sphereNode
    }()
    
    init(worldMap: ARWorldMap) {
       self.worldMap = worldMap
       super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        visualizeWorldMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupSceneView() {
          // 1
       sceneView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(sceneView)
       NSLayoutConstraint.activate(
          [sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           sceneView.rightAnchor.constraint(equalTo: view.rightAnchor),
           sceneView.topAnchor.constraint(equalTo: view.topAnchor),
           sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
    )
          // 2
       scene.rootNode.addChildNode(omniLightNode)
       scene.rootNode.addChildNode(cameraNode)
          // 3
       sceneView.scene = scene
       sceneView.autoenablesDefaultLighting = true
          sceneView.backgroundColor = .systemBackground
       sceneView.allowsCameraControl = true
    }
    
    private func visualizeWorldMap() {
          // 1
       for point in worldMap.rawFeaturePoints.points {
                // 2
          sphereNode.position = SCNVector3(
             point.x, point.y, point.z)
                // 3
          sceneView.scene?.rootNode.addChildNode(
             sphereNode.clone())
       }
    }
}
