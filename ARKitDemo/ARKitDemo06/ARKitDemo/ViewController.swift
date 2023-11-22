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
    @IBOutlet weak var segementControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLighting()
        addTapGestureToSceneView()
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
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    func addTapGestureToSceneView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addObectToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func addObectToSceneView(withGestureRecognizer recognizer: UITapGestureRecognizer){
        let tapLocation = recognizer.location(in: sceneView)
        switch segementControl.selectedSegmentIndex{
        case 0:
            addShipToSceneView(location: tapLocation)
        case 1:
            addBoatToSceneView(location: tapLocation)
        default:
            break
        }
    }
    
    
    @objc func addShipToSceneView(location: CGPoint){

        guard let query = sceneView.raycastQuery(from: location, allowing: .existingPlaneInfinite, alignment: .any) else {
           return
        }
        let hitTestResults = sceneView.session.raycast(query)
//        let hitTestResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y
        let z = translation.z
        guard let shipScene = SCNScene(named: "ship.scn"),
                let shipNode = shipScene.rootNode.childNode(withName: "ship", recursively: false)
        else {return}
        shipNode.position = SCNVector3(x, y, z)
        sceneView.scene.rootNode.addChildNode(shipNode)
    }
    
    func addBoatToSceneView(location: CGPoint){
        guard let raycastQuery = sceneView.raycastQuery(from: location, allowing: .existingPlaneInfinite, alignment: .any),
              let raycastResult = sceneView.session.raycast(raycastQuery).first else{return}
        guard let boatURL = Bundle.main.url(forResource: "boat", withExtension: "usdz"),
              let boatReferenceNode = SCNReferenceNode(url: boatURL) else {return}
        boatReferenceNode.load()
        boatReferenceNode.simdPosition = raycastResult.worldTransform.translation
        sceneView.scene.rootNode.addChildNode(boatReferenceNode)
    }
}

extension float4x4 {
    var translation: SIMD3<Float>{
        let translation = columns.3
        return SIMD3(translation.x, translation.y, translation.z)
    }
}

extension UIColor {
    @objc open class var transparentLightBlue: UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
    }
}

extension ViewController: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
              let planeNode = node.childNodes.first,
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
        
    }
}
