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
    @IBOutlet weak var label:UILabel!
    
    var worldMapURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("worldMapURL")
        } catch {
                fatalError("Error getting world map URL from document directory.")
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate  = self
        configureLighting()
        addTapGestureToSceneView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didReceiveTapGesture(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didReceiveTapGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        guard let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        else {
           return
        }
        let hitTestResults = sceneView.session.raycast(query)
        guard let hitTestResult = hitTestResults.first else {
           return
        }
        
//        guard let hitTestResult = sceneView.hitTest(location, types: [.featurePoint, .estimatedHorizontalPlane]).first
//          else { return }
        let anchor = ARAnchor(transform: hitTestResult.worldTransform)
        sceneView.session.add(anchor: anchor)
    }
    
    func generateSphereNode() -> SCNNode {
        let sphere = SCNSphere(radius: 0.05)
        let sphereNode = SCNNode()
        sphereNode.position.y += Float(sphere.radius)
        sphereNode.geometry = sphere
        return sphereNode
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func resetTrackingConfiguration(with worldMap: ARWorldMap? = nil) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        if let worldMap = worldMap {
            configuration.initialWorldMap = worldMap
            setLabel(text: "Found saved world map.")
        } else {
            setLabel(text: "Move camera around to map your surrounding space.")
        }
        sceneView.debugOptions = [.showFeaturePoints]
        sceneView.session.run(configuration, options: options)
    }
    func setLabel(text: String) {
        label.text = text
    }
    
    func archive(worldMap: ARWorldMap) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
        try data.write(to: self.worldMapURL, options: [.atomic])
    }
    
    func unarchive(worldMapData data: Data) -> ARWorldMap?{
        guard let unarchivedObject = (try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data))as ARWorldMap??,
              let worldMap = unarchivedObject else { return nil }
        return worldMap
    }
    
    
    func retrieveWorldMapData(from url: URL) -> Data? {
        do {
            return try Data(contentsOf: self.worldMapURL)
        } catch {
            self.setLabel(text: "Error retrieving world map data.")
            return nil
        }
    }
    @IBAction func resetBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        resetTrackingConfiguration()
    }
    @IBAction func saveBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        sceneView.session.getCurrentWorldMap {(worldMap, error) in
            guard let worldMap = worldMap else {
                return self.setLabel(text: "Error getting current world map.")
            }
            do {
                try self.archive(worldMap: worldMap)
                DispatchQueue.main.async {
                    self.setLabel(text: "World map is saved.")
                }
            } catch {
                fatalError("Error saving world map: \(error.localizedDescription)")
            }
        }
    }
    @IBAction func loadBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        guard let worldMapData = retrieveWorldMapData(from: worldMapURL),
              let worldMap = unarchive(worldMapData: worldMapData) else { return }
        resetTrackingConfiguration(with: worldMap)
    }
    @IBAction func visualizeButtonDidTouchUpInside(_ sender: UIButton) {
        guard let worldMapData = retrieveWorldMapData(from: worldMapURL),
           let worldMap = unarchive(worldMapData: worldMapData) else { return }
        let visualizationViewController =
           VisualizationViewController(worldMap: worldMap)
        let navigationController = UINavigationController(
           rootViewController: visualizationViewController)
        navigationController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
           self?.present(navigationController, animated: true)
        }
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard !(anchor is ARPlaneAnchor) else { return }
        let sphereNode = generateSphereNode()
        DispatchQueue.main.async{
            node.addChildNode(sphereNode)
        }
    }
    
}
