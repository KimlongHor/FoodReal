//
//  CameraViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/16/23.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    // Capture session
    var session: AVCaptureSession?
    
    // Photo output
    let output = AVCapturePhotoOutput()
    
    // Video preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    private let shutterButton: UIButton = {
        let button = UIButton(frame: .init(x: 0, y: 0, width: 80, height: 80))
        button.createRoundCorner(cornerRadius: 40)
        button.createBorder(color: .white, width: 10)
        return button
    }()
    
    lazy var previewRoundedView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.createRoundCorner(cornerRadius: 8)
        view.frame = .init(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height/1.5)
        view.layer.masksToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
        setupNavBar()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = previewRoundedView.layer.bounds
        previewRoundedView.layer.addSublayer(previewLayer)
        shutterButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 100)
    }
    
    fileprivate func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    fileprivate func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                
                session.startRunning()
                self.session = session
            } catch {
                print("Failed to setup camera")
            }
        }
    }
    
    fileprivate func setupView() {
        view.backgroundColor = .black
        
        view.addSubview(previewRoundedView)
        view.addSubview(shutterButton)
        shutterButton.addTarget(self, action: #selector(takePhotoButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func setupNavBar() {
        let label = UILabel()
        let titleAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 25), .foregroundColor: UIColor.white]
        let attributeString = NSMutableAttributedString(string: "FoodReal.", attributes: titleAttribute)

        label.attributedText = attributeString
        label.sizeToFit()
        navigationItem.titleView = label
    }
    
    @objc fileprivate func takePhotoButtonPressed() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        // this is the image from the camera
        let image = UIImage(data: data)
        
        // just to show on the screen
        session?.stopRunning()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
}
