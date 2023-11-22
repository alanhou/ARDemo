//
//  Extensions.swift
//  ARKitDemo
//
//  Created by alan on 9/14/23.
//
import UIKit
import ARKit

extension float4x4 {
    var translation: SIMD3<Float>{
        let translation = columns.3
        return SIMD3(translation.x, translation.y, translation.z)
    }
}

extension UIColor {
  @objc open class var transparentWhite: UIColor {
    UIColor.white.withAlphaComponent(0.7)
  }
  
  @objc open class var transparentOrange: UIColor {
    UIColor(named: "CustomOrange") ?? .systemOrange
  }
}
