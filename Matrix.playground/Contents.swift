import UIKit
import ARKit
import PlaygroundSupport

// Scene View Setup
let frame = CGRect(
    x: 0, y: 0, width: 512, height: 512)
let sceneView = SCNView(frame: frame)
let scene = SCNScene()
sceneView.autoenablesDefaultLighting = true
sceneView.scene = scene
PlaygroundPage.current.liveView = sceneView

// Light
let lightNode = SCNNode()
let light = SCNLight()
light.type = .omni
lightNode.light = light
lightNode.simdPosition = simd_float3(-2, 10, 5)
scene.rootNode.addChildNode(lightNode)

// Camera
let camera = SCNCamera()
let cameraNode = SCNNode()
cameraNode.camera = camera
cameraNode.rotation.y = GLKMathDegreesToRadians(45)
cameraNode.position = SCNVector3(x:0, y: 2, z: 5)
scene.rootNode.addChildNode(cameraNode)

// Cube
let cubeLength: CGFloat = 1
let cube = SCNBox(width: cubeLength, height: cubeLength, length: cubeLength, chamferRadius: 0
)
cube.firstMaterial?.diffuse.contents = UIColor.red
let cubeNode = SCNNode(geometry: cube)
cubeNode.simdPosition = simd_float3(x: 0, y: 1, z: -0.5)
scene.rootNode.addChildNode(cubeNode)
print(cubeNode.simdTransform)

// Rotation
let rotationDuration: TimeInterval = 6
let xRotation = CGFloat(GLKMathDegreesToRadians(-390))
let yRotation = CGFloat(GLKMathDegreesToRadians(45))
let zRotation = CGFloat(GLKMathDegreesToRadians(60))
let rotationAction = SCNAction.rotateBy(x: xRotation, y: yRotation, z: zRotation, duration: rotationDuration)
rotationAction.timingMode = .easeInEaseOut
cubeNode.runAction(rotationAction){
    print("Cube Node Rotation:", cubeNode.simdRotation)
    print("X:", GLKMathRadiansToDegrees(cubeNode.simdRotation.x))
    print("Y:", GLKMathRadiansToDegrees(cubeNode.simdRotation.y))
    print("Z:", GLKMathRadiansToDegrees(cubeNode.simdRotation.z))
    print("Cube Node Transform:", cubeNode.simdTransform)
}

// Scaling
let scaleActionDuration: TimeInterval = 4
let scaleDownAction = SCNAction.scale(by: 0.5, duration: scaleActionDuration)
let scaleUpAction = SCNAction.scale(by: 1.5, duration: scaleActionDuration)
let scaleSequenceAction = SCNAction.sequence([scaleDownAction, scaleUpAction])
scaleSequenceAction.timingMode = .easeInEaseOut
cubeNode.runAction(scaleSequenceAction) {
    print("Cube Node Scaling:", cubeNode.simdScale)
    print("Cube Node Transform:", cubeNode.simdTransform)
}
