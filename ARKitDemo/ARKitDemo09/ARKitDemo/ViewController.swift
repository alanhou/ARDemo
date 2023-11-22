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
    
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 0.5
    
    var catReferenceImages: Set<ARReferenceImage>  = []
    
    lazy var fadeAndSpinAction: SCNAction = {
        return .sequence([
            .fadeIn(duration: fadeDuration),
            .rotateBy(x: 0, y: 0, z: CGFloat.pi * 360 / 100, duration: rotateDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
        ])
    }()
    
    lazy var fadeAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.8, duration: fadeDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
        ])
    }()
    
    lazy var treeNode: SCNNode = {
       guard let scene = SCNScene(named: "tree.scn"),
             let node = scene.rootNode.childNode(withName: "tree", recursively: false) else { return SCNNode() }
        let scaleFactor = 0.005
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x = -.pi / 2
        return node
    }()
    
    lazy var bookNode: SCNNode = {
       guard let scene = SCNScene(named: "book.scn"),
             let node = scene.rootNode.childNode(withName: "book", recursively: false) else { return SCNNode() }
        let scaleFactor = 0.1
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        return node
    }()
    
    lazy var mountainNode: SCNNode = {
       guard let scene = SCNScene(named: "mountain.scn"),
             let node = scene.rootNode.childNode(withName: "mountain", recursively: false) else { return SCNNode() }
        let scaleFactor = 0.25
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x += -.pi / 2
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate  = self
        configureLighting()
        guard let catImageUrl = URL(
            string: "https://bit.ly/2XB83sl")
        else { return }
        downloadImageWithURL(catImageUrl)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    @IBAction func resetButtonDidTouch(_ sender: UIBarButtonItem) {
        resetTrackingConfiguration()
    }
    
    func resetTrackingConfiguration() {
        guard let referenceImages = ARReferenceImage
            .referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        else { return }
        let configuration = ARWorldTrackingConfiguration()
//        configuration.detectionImages = referenceImages
        let detectionImages = referenceImages.union(catReferenceImages)
        configuration.detectionImages = detectionImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
        DispatchQueue.main.async {
            self.label.text = "Move camera around to detect images"
        }
    }
    
    func makeReferenceImageFromImage(_ image: UIImage){
        guard let cgImage = image.cgImage else { return }
        let referenceImage = ARReferenceImage(
            cgImage, orientation: .up,
            physicalWidth: CGFloat(cgImage.width / 1000))
        referenceImage.name = "cat"
        catReferenceImages.insert(referenceImage)
        debugPrint("Did insert cat reference image.")
        resetTrackingConfiguration()
    }
    
    func downloadImageWithURL(_ url: URL) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            guard let data = data,
                  let image = UIImage(data: data)
            else { return }
            self.makeReferenceImageFromImage(image)
        }.resume()
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
//        let referenceImage = imageAnchor.referenceImage
//        let imageName = referenceImage.name ?? "no name"
        let planeNode = getPlaneNode(withReferenceImage: imageAnchor.referenceImage)
        planeNode.opacity = 0.20
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.runAction(fadeAction)
        node.addChildNode(planeNode)
        DispatchQueue.main.async{
            guard let imageAnchor = anchor as? ARImageAnchor,
                  let imageName = imageAnchor.referenceImage.name else { return }
            let overlayNode = self.getNode(withImageName: imageName)
            overlayNode.opacity = 0
            overlayNode.position.y = 0.2
            overlayNode.runAction(self.fadeAndSpinAction)
            node.addChildNode(overlayNode)
            self.label.text = "Image detected: \"\(imageName)\""
        }
    }
    
    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width, height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }
    
    func getNode(withImageName name: String) -> SCNNode {
        var node = SCNNode()
        switch name {
        case "Book":
            node = bookNode
        case "Snow Mountain":
            node = mountainNode
        case "Trees In the Dark":
            node = treeNode
        default:
            break
        }
        return node
    }
}
