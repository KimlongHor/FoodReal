//
//  CameraViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/16/23.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    @IBOutlet weak var photoPreviewImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    fileprivate func setupView() {
//        session = AVCaptureSession()
//        session!.sessionPreset = AVCaptureSession.Preset.Photo
//        let backCamera =  AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//        var error: NSError?
//        var input: AVCaptureDeviceInput!
//        do {
//            input = try AVCaptureDeviceInput(device: backCamera)
//        } catch let error1 as NSError {
//            error = error1
//            input = nil
//            print(error!.localizedDescription)
//        }
//        if error == nil && session!.canAddInput(input) {
//            session!.addInput(input)
//            stillImageOutput = AVCaptureStillImageOutput()
//            stillImageOutput?.outputSettings = [AVVideoCodecKey:  AVVideoCodecJPEG]
//            if session!.canAddOutput(stillImageOutput) {
//                session!.addOutput(stillImageOutput)
//                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
//                videoPreviewLayer!.videoGravity =    AVLayerVideoGravityResizeAspect
//                videoPreviewLayer!.connection?.videoOrientation =   AVCaptureVideoOrientation.Portrait
//                previewView.layer.addSublayer(videoPreviewLayer!)
//                session!.startRunning()
//            }
//        }
    }
    
    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        
    }
}
