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
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var lightEstimationStackView: UIStackView!
    
    @IBOutlet weak var ambientIntensityLabel: UILabel!
    @IBOutlet weak var ambientColorTemperatureLabel: UILabel!
    
    @IBOutlet weak var roughnessLabel: UILabel!
    @IBOutlet weak var metalnessLabel: UILabel!
    
    @IBOutlet weak var ambientIntensitySlider: UISlider!
    @IBOutlet weak var ambientColorTemperatureSlider: UISlider!
    
    @IBOutlet weak var lightEstimationSwitch: UISwitch!
    
    var lightNodes = [SCNNode]()
    var sphereNodes = [SCNNode]()
    
    var detectedHorizontalPlane = false {
        didSet{
            DispatchQueue.main.async {
                self.mainStackView.isHidden = !self.detectedHorizontalPlane
                self.instructionLabel.isHidden = self.detectedHorizontalPlane
                self.lightEstimationStackView.isHidden = !self.detectedHorizontalPlane
            }
        }
    }
    
    let sphereMaterial: SCNMaterial = {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = 0
        material.roughness.contents = 0
        return material
    }()
    
    private var ballProbeAnchor: AREnvironmentProbeAnchor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func setUpSceneView() {
      let configuration = ARWorldTrackingConfiguration()
      configuration.planeDetection = .horizontal
      configuration.environmentTexturing = .automatic
      sceneView.debugOptions = [.showFeaturePoints]
      sceneView.session.run(configuration,
                            options: [.removeExistingAnchors])
      sceneView.delegate = self
    }
    
    private func addTapGesture() {
      let tapGestureRecognizer = UITapGestureRecognizer(
        target: self, action: #selector(didRegisterTapGestureRecognizer(_:)))
      sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didRegisterTapGestureRecognizer(
      _ recognizer: UITapGestureRecognizer) {
      let tapLocation = recognizer.location(in: sceneView)
      guard let raycastQuery = sceneView.raycastQuery(
      from: tapLocation,
      allowing: .estimatedPlane,
      alignment: .any),
      let raycastResult = sceneView.session.raycast(
        raycastQuery).first else { return }
      let sphereNode = getSphereNode(
        withPosition: raycastResult.worldTransform.translation)
      addLightNodeTo(sphereNode)
      sceneView.scene.rootNode.addChildNode(sphereNode)
    }
    
    func getSphereNode(withPosition position: SIMD3<Float>, height: Float = 0) -> SCNNode {
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial = sphereMaterial
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.simdPosition = position
        sphereNode.position.y += Float(sphere.radius) + height
        return sphereNode
    }
    
    func getLightNode() -> SCNNode {
        let light = SCNLight()
        light.type = .omni
        light.intensity = 0
        light.temperature = 0
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(0,1,0)
        return lightNode
    }
    
    func addLightNodeTo(_ node: SCNNode) {
        let lightNode = getLightNode()
        node.addChildNode(lightNode)
        lightNodes.append(lightNode)
    }
    
    func updateLightNodesLightEstimation(){
        DispatchQueue.main.async{
            guard self.lightEstimationSwitch.isOn,
                  let lightEstimate = self.sceneView.session.currentFrame?.lightEstimate
            else { return }
            let ambientIntensity = lightEstimate.ambientIntensity
            let ambientColorTemaperature = lightEstimate.ambientColorTemperature
            for lightNode in self.lightNodes {
                guard let light = lightNode.light else { continue }
                light.intensity = ambientIntensity
                light.temperature = ambientColorTemaperature
            }
        }
    }
    
    @IBAction func ambientIntensitySliderValueDidChange(_ sender: UISlider) {
        DispatchQueue.main.async {
            let ambientIntensity = sender.value
            self.ambientIntensityLabel.text = "Ambient Intensity: \(ambientIntensity)"
            guard !self.lightEstimationSwitch.isOn else { return }
            for lightNode in self.lightNodes {
                guard let light = lightNode.light else { continue }
                light.intensity = CGFloat(ambientIntensity)
            }
        }
    }
    
    @IBAction func ambientColorTemperatureSliderValueDidChange(_ sender: UISlider) {
        DispatchQueue.main.async{
            let ambientColorTemperature = self.ambientColorTemperatureSlider.value
            self.ambientColorTemperatureLabel.text = "Ambient Color Temperature: \(ambientColorTemperature)"
            guard !self.lightEstimationSwitch.isOn else { return }
            for lightNode in self.lightNodes {
                guard let light = lightNode.light else { continue }
                light.temperature = CGFloat(ambientColorTemperature)
            }
        }
    }
    
    @IBAction func lightEstimationSwitchValueDidChange(_ sender: UISwitch) {
        ambientIntensitySliderValueDidChange(ambientIntensitySlider)
        ambientColorTemperatureSliderValueDidChange(ambientColorTemperatureSlider)
    }
    
    @IBAction func roughnessSliderValueDidChange(_ sender: UISlider) {
        let roughness = sender.value
        DispatchQueue.main.async{
            self.roughnessLabel.text = "Roughness: \(roughness)"
            self.sphereMaterial.roughness.contents = roughness
        }
    }
    
    @IBAction func metalnessSliderValueDidChange(_ sender: UISlider) {
        let metalness = sender.value
        DispatchQueue.main.async{
            self.metalnessLabel.text = "Metalness: \(metalness)"
            self.sphereMaterial.metalness.contents = metalness
        }
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        let sphereNode = getSphereNode(withPosition: node.simdWorldPosition, height: 1)
        addLightNodeTo(sphereNode)
        node.addChildNode(sphereNode)
        detectedHorizontalPlane = true
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        updateLightNodesLightEstimation()
    }
}
