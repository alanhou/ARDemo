//
//  ApplicatonData.swift
//  Test
//
//  Created by Alan on 2023/11/27.
//

import SwiftUI
import Observation
import AVFoundation

class ViewData {
    var captureDevice: AVCaptureDevice?
    var captureSession: AVCaptureSession?
    var stillImage: AVCapturePhotoOutput?
    var rotationCoordinator: AVCaptureDevice.RotationCoordinator?
    var previewObservation: NSKeyValueObservation?
}
@Observable class ApplicatonData: NSObject, AVCapturePhotoCaptureDelegate {
    var path = NavigationPath()
    var picture: UIImage?
    @ObservationIgnored var cameraView: CustomPreview!
    @ObservationIgnored var viewData: ViewData!
    
    override init() {
        cameraView = CustomPreview()
        viewData = ViewData()
    }
}
