//
//  VideoPreviewView.swift
//  PhotoColorPicker
//
//  Created by Kaiser, Austin on 9/25/17.
//  Copyright © 2017 Kaiser, Austin. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPreviewView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        
        return layer as! AVCaptureVideoPreviewLayer
        
    }
    
    var session: AVCaptureSession? {
        
        get { return videoPreviewLayer.session }
        set { videoPreviewLayer.session = newValue }
        
    }
    
    override class var layerClass: AnyClass {
        
        return AVCaptureVideoPreviewLayer.self
        
    }
    
    private var orientationMap: [UIDeviceOrientation : AVCaptureVideoOrientation] = [
        
        .portrait           : .portrait,
        .portraitUpsideDown : .portraitUpsideDown,
        .landscapeLeft      : .landscapeRight,
        .landscapeRight     : .landscapeLeft,
        
        ]
    
    func updateVideoOrientationForDeviceOrientation() {
        
        if let videoPreviewLayerConnection = videoPreviewLayer.connection {
            let deviceOrientation = UIDevice.current.orientation
            guard let newVideoOrientation = orientationMap[deviceOrientation],
                deviceOrientation.isPortrait || deviceOrientation.isLandscape
                else { return }
            videoPreviewLayerConnection.videoOrientation = newVideoOrientation
            
        }
        
    }

}
