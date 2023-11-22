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
        addBox()
        addTapGestureToSceneView()
        addPanGestureToSceneView()
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
    
    func addBox(x:Float=0, y:Float=0, z:Float = -0.2){
        let box = SCNBox(width: 2, height: 0.2, length: 0.2, chamferRadius: 0)
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(x, y, z)
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    func addTapGestureToSceneView() {
      let tapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action:  #selector(ViewController.didTap(withGestureRecognizer:)))
      sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer){
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else{
            let hitTestResultWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultWithFeaturePoints.first{
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return}
        node.removeFromParentNode()
    }
    
    func addPanGestureToSceneView(){
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func didPan(withGestureRecognizer recognizer: UIPanGestureRecognizer){
        switch recognizer.state{
        case .began:
            print("Pan Began")
        case .changed:
            print("Pan Changed")
            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(tapLocation)
            guard let node = hitTestResults.first?.node,
                     let hitTestResultWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint).first else{return}
            let worldTransform = SCNMatrix4(hitTestResultWithFeaturePoints.worldTransform)
            node.setWorldTransform(worldTransform)
        case .ended:
            print("Pan Ended")
        default:
            break
        }
    }
}

extension float4x4 {
    var translation: SIMD3<Float>{
        let translation = self.columns.3
        return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
}
