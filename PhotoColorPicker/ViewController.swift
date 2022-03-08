//
//  ViewController.swift
//  PhotoColorPicker
//
//  Created by Kaiser, Austin on 9/15/17.
//  Copyright © 2017 Kaiser, Austin. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cameraController = CameraController()
    
    let picker = UIImagePickerController()
    
    let segueToImageView = "ImageViewControllerSegue"
    
    var selectedImage: UIImage?

    @IBOutlet weak var takePictureButton: UIButton!
    
    @IBOutlet weak var cameraView: UIImageView!
    
    @IBOutlet weak var switchCameraButton: UIBarButtonItem!
    
    
    
    @IBAction func switchCameras(_ sender: UIBarButtonItem) {
        
        do {
            try cameraController.switchCameras()
        }
            
        catch {
            print(error)
        }
        
    }
    
    
    @IBAction func captureImage(_ sender: UIButton) {
        
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
            
        }
        
    }
    
    @IBAction func openCameraRoll(_ sender: Any) {
        
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        func configureCameraController() {
            
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.cameraView)
            }
            
        }
        
        picker.delegate = self
        
        configureCameraController()
        
        completeAuthorization()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkCameraAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
        
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
            
        case .authorized:
            //The user has previously granted access to the camera.
            completionHandler(true)
            
        case .notDetermined:
            // The user has not yet been presented with the option to grant video access so request access.
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { success in
                completionHandler(success)
            })
            
        case .denied:
            // The user has previously denied access.
            completionHandler(false)
            
        case .restricted:
            // The user doesn't have the authority to request access e.g. parental restriction.
            completionHandler(false)
            
        }
        
    }
    
    func checkPhotoLibraryAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
        
        switch PHPhotoLibrary.authorizationStatus() {
            
        case .authorized:
            // The user has previously granted access to the photo library.
            completionHandler(true)
            
        case .notDetermined:
            // The user has not yet been presented with the option to grant photo library access so request access.
            PHPhotoLibrary.requestAuthorization({ status in
                completionHandler((status == .authorized))
            })
            
        case .denied:
            // The user has previously denied access.
            completionHandler(false)
            
        case .restricted:
            // The user doesn't have the authority to request access e.g. parental restriction.
            completionHandler(false)
            
        }
        
    }
    
    func completeAuthorization() {
        
        self.checkCameraAuthorization { authorized in
            if authorized {
                // Proceed to set up and use the camera.
            } else {
                print("Permission to use camera denied.")
            }
        }
        
        self.checkPhotoLibraryAuthorization { authorized in
            
            if authorized {
                // gain access to photo library
            } else {
                print("Permission to use camera denied")
            }
            
        }
        
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = image
            
            picker.dismiss(animated: true, completion: nil)
            
            performSegue(withIdentifier: segueToImageView, sender: self)
            
        } else {
            print("Something went wrong")
        }
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueToImageView {
            
            if let nextViewController = segue.destination as? SelectedImageViewController {
                nextViewController.image = selectedImage
            }
            
        }
        
    }
    
}
