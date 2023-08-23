//
//  ContentView.swift
//  ARDemo
//
//  Created by Alan on 8/8/23.
//

import SwiftUI
import RealityKit
import ARKit
import VideoToolbox
import Combine

struct ContentView : View {
    var body: some View {
        ARViewContainer()
            .overlay(
                VStack{
                    Spacer()
                    HStack{
                        Button(action:{arView.loadARWorldMap()}) {
                            Text("加载地图")
                                .frame(width:120,height:40)
                                .font(.body)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .opacity(0.6)
                        }
                        .offset(y:-30)
                        .padding(.bottom, 30)
                        Button(action: {arView.saveARWorldMap()}) {
                            Text("保存地图")
                                .frame(width:120,height:40)
                                .font(.body)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .opacity(0.6)
                        }
                        .offset(y:-30)
                        .padding(.bottom, 30)
                    }
                }
            )
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config, options: [])
        arView.session.delegate = arView
        arView.createPlane()
        arView.setupGestures()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

var arView : ARView!
var planeMesh = MeshResource.generatePlane(width: 0.15, depth: 0.15)
var planeMaterial = SimpleMaterial(color: .white, isMetallic: false)
var planeEntity : ModelEntity? = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
var planeAnchor = AnchorEntity()
var raycastResult: ARRaycastResult?
var isPlaced = false
var robotAnchor: AnchorEntity?
let robotAnchorName = "drummerRobot"

var mapSaveURL: URL = {
    do {
        return try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask,
                appropriateFor: nil, create: true
            ).appendingPathComponent("arworldmap.arexperience")
    } catch{
        fatalError("获取路径出错：\(error.localizedDescription)")
    }
}()

extension ARView : ARSessionDelegate{
    func createPlane(){
        let planeAnchor = AnchorEntity(plane: .horizontal)
        do {
            planeMaterial.color = try .init(tint: UIColor.yellow.withAlphaComponent(0.9999), texture: .init(.load(named: "AR_Placement_Indicator.png")))
            planeAnchor.addChild(planeEntity!)
            self.scene.addAnchor(planeAnchor)
        } catch {
            print("找不到文件")
        }
    }
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if(isPlaced){return}
        guard let result = self.raycast(from: self.center, allowing: .estimatedPlane, alignment: .horizontal).first else{
            return
        }
        raycastResult = result
        planeEntity!.setTransformMatrix(result.worldTransform, relativeTo: nil)
    }
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let pAnchor = anchors.first,robotAnchor == nil, pAnchor.name == robotAnchorName else {
            return
        }
        let usdzPath = "toy_drummer"
        var cancellable: AnyCancellable? = nil
        cancellable = ModelEntity.loadModelAsync(named: usdzPath)
            .sink(receiveCompletion: { error in
                print("发生错误：\(error)")
                cancellable?.cancel()
            }, receiveValue: {entity in
                robotAnchor = AnchorEntity(anchor: pAnchor)
                robotAnchor!.addChild(entity)
                self.scene.addAnchor(robotAnchor!)
                cancellable?.cancel()
            })
        isPlaced = true
        planeEntity?.removeFromParent()
        planeEntity = nil
        print("加载模型成功")
    }
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil){
        sender?.isEnabled = false
        sender?.removeTarget(nil, action: nil)
        isPlaced = true
        let anchor = ARAnchor(name: robotAnchorName, transform: raycastResult!.worldTransform)
        self.session.add(anchor: anchor)
        robotAnchor = AnchorEntity(anchor: anchor)
        let usdzPath = "toy_drummer"
        var cancellable: AnyCancellable? = nil
        cancellable = ModelEntity.loadModelAsync(named: usdzPath).sink(receiveCompletion: {error in
            print("发生错误：\(error)")
            cancellable?.cancel()
        }, receiveValue: {entity in
            robotAnchor!.addChild(entity)
            self.scene.addAnchor(robotAnchor!)
            cancellable?.cancel()
        })
        planeEntity?.removeFromParent()
        planeEntity = nil
    }
    
    func saveARWorldMap() {
        self.session.getCurrentWorldMap{worldMap, error in
            guard let map = worldMap
            else {print("当前无法获取ARWorldMap:\(error!.localizedDescription)"); return}
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try data.write(to: mapSaveURL, options: [.atomic])
                print("ARWorldMap保存成功")
            } catch {
                fatalError("无法保存 ARWorldMap:\(error.localizedDescription)")
            }
        }
    }
    
    
    var mapDataFromFile: Data? {
        return try? Data(contentsOf: mapSaveURL)
    }
    
    func loadARWorldMap() {
        let worldMap: ARWorldMap = {
            guard let data = mapDataFromFile
            else {fatalError("ARWorldMap 文件不存在")}
        
            do{
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
                else {fatalError("ARWorldMap 文件格式不正确")}
                return worldMap
            } catch {
                fatalError("无法解压ARWorldMap:\(error)")
            }
        }()
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.initialWorldMap = worldMap
        self.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        print("ARWorldMap 加载成功")
    }
}



#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
