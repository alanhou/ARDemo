//
//  ViewController.swift
//  ARKitDemo
//
//  Created by alan on 9/13/23.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    var isFistRocketLanded = true
    let rocketshipNodeName = "rocketship"
    var planeNodes = [SCNNode]()
    var isFirstRocketLanded = true
    
    enum CollisionBody: Int {
        case plane = 1
        case rocket = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSceneView()
        configureLighting()
        addSwipeGesturesToSceneView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func configureLighting(){
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func setUpSceneView(){
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        sceneView.debugOptions = [.showPhysicsShapes]
    }
    
    func addTapGestureToSceneView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addRocketshipToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func addRocketshipToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        guard let query = sceneView.raycastQuery(from: tapLocation, allowing: .existingPlaneInfinite, alignment: .any) else {
           return
        }
        let hitTestResults = sceneView.session.raycast(query)
        guard let hitTestResult = hitTestResults.first else { return }
        
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y + 0.1
        let z = translation.z
        
        guard let rocketshipScene = SCNScene(named: "rocketship.scn"),
              let rocketshipNode = rocketshipScene.rootNode.childNode(withName: "rocketship", recursively: false) else { return }
        
        rocketshipNode.position = SCNVector3(x, y, z)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        rocketshipNode.physicsBody = physicsBody
        rocketshipNode.name = rocketshipNodeName
        setRocketCollisionBitmask(onNode: rocketshipNode)
        sceneView.scene.rootNode.addChildNode(rocketshipNode)
    }
    
    func getRocketshipNode(from swipeLocation: CGPoint) -> SCNNode? {
        let hitTestResults = sceneView.hitTest(swipeLocation)
        guard let parentNode = hitTestResults.first?.node.parent,
              parentNode.name == rocketshipNodeName
        else { return nil }
        return parentNode
    }
    
    @objc func applyForceToRocketship(withGestureRecognizer recognizer: UIGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        let swipeLocation = recognizer.location(in: sceneView)
        guard let rocketshipNode = getRocketshipNode(from: swipeLocation),
              let physicsBody = rocketshipNode.physicsBody
        else { return }
        let direction = SCNVector3(0, 3, 0)
        physicsBody.applyForce(direction, asImpulse: true)
    }
    
    @objc func launchRocketship(withGestureRecognizer recognizer: UIGestureRecognizer){
        guard recognizer.state == .ended else { return }
        let swipeLocation = recognizer.location(in: sceneView)
        guard let rocketshipNode = getRocketshipNode(from: swipeLocation),
              let physicsBody = rocketshipNode.physicsBody,
              let reactorParticleSystem = SCNParticleSystem(named: "reactor", inDirectory: nil),
              let engineNode = rocketshipNode.childNode(withName: "node2", recursively: false)
        else { return }
        
        physicsBody.isAffectedByGravity = false
        physicsBody.damping = 0
        
        reactorParticleSystem.colliderNodes = planeNodes
        engineNode.addParticleSystem(reactorParticleSystem)
        let action = SCNAction.moveBy(x: 0, y: 0.3, z: 0, duration: 3)
        action.timingMode = .easeInEaseOut
        rocketshipNode.runAction(action)
    }
    
    func addSwipeGesturesToSceneView() {
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.applyForceToRocketship(withGestureRecognizer:)))
        swipeUpGestureRecognizer.direction = .up
        sceneView.addGestureRecognizer(swipeUpGestureRecognizer)
        
        let swipeDownGestureRecoginzer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.launchRocketship(withGestureRecognizer:)))
        swipeDownGestureRecoginzer.direction = .down
        sceneView.addGestureRecognizer(swipeDownGestureRecoginzer)
    }
    
    func setRocketCollisionBitmask(onNode node: SCNNode) {
        node.physicsBody?.categoryBitMask = CollisionBody.rocket.rawValue
        node.physicsBody?.collisionBitMask = CollisionBody.plane.rawValue
        node.physicsBody?.contactTestBitMask = CollisionBody.plane.rawValue
    }
    
    func setPlaneCollisionBitmask(onNode node: SCNNode) {
        node.physicsBody?.categoryBitMask = CollisionBody.plane.rawValue
        node.physicsBody?.collisionBitMask = CollisionBody.rocket.rawValue
        node.physicsBody?.contactTestBitMask = CollisionBody.rocket.rawValue
    }
}

extension ViewController: ARSCNViewDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let width = CGFloat(planeAnchor.planeExtent.width)
        let height = CGFloat(planeAnchor.planeExtent.height)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = UIColor.transparentWhite

        
        var planeNode = SCNNode(geometry: plane)
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y ,z)
        planeNode.eulerAngles.x = -.pi / 2
        update(&planeNode, withGeometry: plane, type: .static)
        node.addChildNode(planeNode)
        planeNodes.append(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor,
              let planeNode = node.childNodes.first
        else { return }
        planeNodes = planeNodes.filter{ $0 != planeNode }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
              var planeNode = node.childNodes.first,
              let plane = planeNode.geometry as? SCNPlane
        else { return}
        
        let width = CGFloat(planeAnchor.planeExtent.width)
        let height = CGFloat(planeAnchor.planeExtent.height)
        plane.width = width
        plane.height = height
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y ,z)
        update(&planeNode, withGeometry: plane, type: .static)
    }
    
    func update(_ node: inout SCNNode, withGeometry geometry: SCNGeometry, type: SCNPhysicsBodyType) {
        let shape = SCNPhysicsShape(geometry: geometry, options: nil)
        let physicsBody = SCNPhysicsBody(type: type, shape: shape)
        node.physicsBody = physicsBody
        setPlaneCollisionBitmask(onNode: node)
    }
}

extension ViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        guard (contact.nodeA.physicsBody?.categoryBitMask == CollisionBody.plane.rawValue && contact.nodeB.physicsBody?.categoryBitMask == CollisionBody.rocket.rawValue) || (contact.nodeA.physicsBody?.categoryBitMask == CollisionBody.rocket.rawValue && contact.nodeB.physicsBody?.categoryBitMask == CollisionBody.plane.rawValue)
        else { return }
        guard isFirstRocketLanded else { return }
        isFistRocketLanded = false
        for planeNode in planeNodes {
            planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.transparentOrange
        }
    }
}
