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

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label:UILabel!
    
    private let worldTrackingConfiguration: ARWorldTrackingConfiguration = {
       let worldTrackingConfiguration = ARWorldTrackingConfiguration()
        worldTrackingConfiguration.planeDetection = .horizontal
        return worldTrackingConfiguration
    }()

    private var isToyRobotAdded = false
    private var isAnimating = false
    
    private var cvPixelBuffer: CVPixelBuffer?
    
    private let anchorName = "toyRobotAnchor"
    private let toyRobotNode: SCNReferenceNode = {
        let resourceName = "toy_robot_vintage"
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "usdz"),
              let referenceNode = SCNReferenceNode(url: url)
        else { fatalError("Failed to load \(resourceName).") }
        referenceNode.load()
        return referenceNode
    }()
    
    private var requestHandler: VNImageRequestHandler? {
        guard let pixelBuffer = cvPixelBuffer,
              let orientation = CGImagePropertyOrientation(rawValue: UInt32(UIDevice.current.orientation.rawValue))
        else { return nil }
        return VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
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
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func resetTrackingConfiguration() {
        sceneView.session.run(worldTrackingConfiguration, options: [.removeExistingAnchors])
    }
    
    private lazy var visionCoreMLRequest: VNCoreMLRequest = {
        do {
            let mlModel = try MLModel(contentsOf: Gesture.urlOfModelInThisBundle)
            let visionModel = try VNCoreMLModel(for: mlModel)
            let request = VNCoreMLRequest(model: visionModel){request, error in
                self.handleObservationClassification(request: request, error: error)
            }
            request.imageCropAndScaleOption = .centerCrop
            return request
            
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }()
    
    
    private func handleObservationClassification(
      request: VNRequest, error: Error?) {
          guard let observations = request.results as? [VNClassificationObservation],
                let observation = observations.first(where: { $0.confidence > 0.8 })
          else { return }
          let identifier = observation.identifier
          let confidence = observation.confidence
          var text = "Show you hand."
          if identifier.lowercased().contains("five"){
              self.moveToyRobot(isForward: true)
              text = "\(confidence) open hand."
          } else if identifier.lowercased().contains("fist") {
              self.moveToyRobot(isForward: false)
              text = "\(confidence) closed fist."
          }
          DispatchQueue.main.async{
              self.label.text = text
          }
    }
    
    private func classifyFrame(_ frame: ARFrame) {
        cvPixelBuffer = frame.capturedImage
        DispatchQueue.global(qos: .background).async {[weak self] in
            guard let self = self else { return }
            do {
                defer {
                    self.cvPixelBuffer = nil
                }
                try self.requestHandler?.perform(
                    [self.visionCoreMLRequest]
                )
            }catch{
                print("Error:", error.localizedDescription)
            }
        }
    }
    
    private func moveToyRobot(isForward: Bool){
        guard !isAnimating else { return }
        isAnimating = true
        let z: CGFloat = isForward ? 0.05 : -0.03
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: z, duration: 1)
        toyRobotNode.runAction(moveAction) {
            self.isAnimating = false
        }
    }
}

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard cvPixelBuffer == nil else { return }
        classifyFrame(frame)
    }
}

extension ViewController: ARSCNViewDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            guard !isToyRobotAdded,
                  anchor is ARPlaneAnchor else { continue }
            isToyRobotAdded = true
            label.isHidden = false
            toyRobotNode.simdTransform = anchor.transform
            DispatchQueue.main.async{
                self.sceneView.scene.rootNode.addChildNode(self.toyRobotNode)
            }
        }
    }
}
