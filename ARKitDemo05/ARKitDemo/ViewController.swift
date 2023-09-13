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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLighting()
//        addPaperPlane()
//        addCar()
        addUFO()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func addPaperPlane(x:Float = 0, y:Float = 0, z:Float = -0.5){
        guard let paperPlaneScene = SCNScene(named: "paperPlane.scn"), let paperPlaneNode = paperPlaneScene.rootNode.childNode(withName: "paperPlane", recursively: true) else {return}
        paperPlaneNode.position = SCNVector3(x, y, z)
        sceneView.scene.rootNode.addChildNode(paperPlaneNode)
    }
    
    func configureLighting(){
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func addCar(x: Float = 0, y: Float = 0, z: Float = -0.5){
        guard let carScene = SCNScene(named: "car.dae") else {return}
        let carNode = SCNNode()
        let carSceneChildNodes = carScene.rootNode.childNodes
        for childNode in carSceneChildNodes {
            carNode.addChildNode(childNode)
        }
        carNode.position = SCNVector3(x, y, z)
        carNode.scale = SCNVector3(0.5, 0.5, 0.5)
        sceneView.scene.rootNode.addChildNode(carNode)
    }
    
    func addUFO(x: Float = 0, y: Float = -0.5, z: Float = -1){
        guard let ufoURL = Bundle.main.url(forResource: "ufo", withExtension: "usdz"),
              let ufoNode = SCNReferenceNode(url: ufoURL) else {return}
        ufoNode.position = SCNVector3(x, y, z)
        ufoNode.load()
        sceneView.scene.rootNode.addChildNode(ufoNode)
    }
}

