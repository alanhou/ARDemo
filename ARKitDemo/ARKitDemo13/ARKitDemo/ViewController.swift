//
//  ViewController.swift
//  ARKitDemo
//
//  Created by alan on 9/13/23.
//

import UIKit
import ARKit
import Vision

class ViewController: UIViewController {
    private let sceneView: ARSCNView = {
        let sceneView = ARSCNView()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.automaticallyUpdatesLighting = true
        return sceneView
    }()
    
    private let lionNode: SCNNode = {
       guard let scene = SCNScene(named: "Lion.scn"),
             let node = scene.rootNode.childNode(withName: "Lion", recursively: false)
        else {fatalError("Lion node could not be found.")}
        return node
    }()
   
    private let audioSource: SCNAudioSource = {
        let fileName = "lion-stereo.mp3"
//        let fileName = "lion-mono.mp3"
        guard let audioSource = SCNAudioSource(fileNamed: fileName)
        else { fatalError("\(fileName) can not be found.")}
        audioSource.loops = true
        audioSource.load()
        return audioSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        setupSceneViewCamera()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private func setupSceneView(){
        view.addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        sceneView.delegate = self
    }
    
    private func resetTrackingConfiguration(){
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func turnOffPlaneDetectionTracking() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [])
    }
    
    private func setupSceneViewCamera() {
        guard let camera = sceneView.pointOfView?.camera else { return }
        camera.wantsHDR = true
    }

    private func addAudioSource() {
        lionNode.removeAllAudioPlayers()
        lionNode.addAudioPlayer(SCNAudioPlayer(source: audioSource))
    }
    
}

extension ViewController: ARSCNViewDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        resetTrackingConfiguration()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        node.addChildNode(lionNode)
        addAudioSource()
        turnOffPlaneDetectionTracking()
    }
}
