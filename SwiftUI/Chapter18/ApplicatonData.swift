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
    
    func getAuthorization() async {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        await MainActor.run {
            if granted {
                self.prepareCamera()
            } else {
                print("Not Authorized")
            }
        }
    }
    
    func prepareCamera() {
        viewData.captureSession = AVCaptureSession()
        viewData.captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        if let _ = try? viewData.captureDevice?.lockForConfiguration() {
            viewData.captureDevice?.isSubjectAreaChangeMonitoringEnabled = true
            viewData.captureDevice?.unlockForConfiguration()
        }
        if let device = viewData.captureDevice {
            if let input = try? AVCaptureDeviceInput(device: device) {
                viewData.captureSession?.addInput(input)
                
                viewData.stillImage = AVCapturePhotoOutput()
                if viewData.stillImage != nil {
                    viewData.captureSession?.addOutput(viewData.stillImage!)
                    if let max = viewData.captureDevice?.activeFormat.supportedMaxPhotoDimensions.last {
                        viewData.stillImage?.maxPhotoDimensions = max
                    }
                }
                showCamera()
            } else {
                print("Not Authorized")
            }
        } else {
            print("Not Authorized")
        }
    }
}
