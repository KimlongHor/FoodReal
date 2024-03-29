//
//  CameraViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/16/23.
//

import LBTATools
import UIKit
import AVFoundation
import FirebaseAuth
import Lottie

protocol CameraViewDelegate {
    func didPost()
}

class CameraViewController: UIViewController {
    
    // Capture session
    var session: AVCaptureSession?
    // Photo output
    let output = AVCapturePhotoOutput()
    // Video preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    // Logged in user
    var currUser: User!
    
    var backInput: AVCaptureInput?
    var frontInput: AVCaptureInput?
    var backImage: UIImage?
    var frontImage: UIImage?
    //var frontData: Data?
    //var backData: Data?
    
    var isBothImageCaptured = false
    var backCameraOn = true
    var previewContainerView: UIView?
    
    var delegate: CameraViewDelegate?
    
    var uploadingView: LottieAnimationView?
    var animationView = UIView(backgroundColor: .black)
    
    private let shutterButton: UIButton = {
        let button = UIButton()
        button.createRoundCorner(cornerRadius: 40)
        button.createBorder(color: .white, width: 5)
        button.addTarget(self, action: #selector(takePhotoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var previewRoundedView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.createRoundCorner(cornerRadius: 15)
        view.frame = .init(x: 0, y: 110, width: self.view.frame.width, height: self.view.frame.height/1.6)
        view.layer.masksToBounds = true
        return view
    }()
    
    let switchCameraButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "switchCamera")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(switchCameraButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let retakeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retake", for: .normal)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.createRoundCorner(cornerRadius: 14)
        button.addTarget(self, action: #selector(handleRetake), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    @objc fileprivate func handleRetake() {
        shutterButton.isHidden = false
        switchCameraButton.isHidden = false
        print("retake pressed.")
        retakeButton.isHidden = true
        guard let previewContainerView = previewContainerView else {return}
        previewContainerView.removeFromSuperview()
        frontImage = nil
        backImage = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
        setupNavBar()
        setupView()
    }
    
    func setupUploadingView() {
        let uploadingLabel = UILabel(text: "Uploading images...", font: .systemFont(ofSize: 10, weight: .semibold), textColor: .white, textAlignment: .center, numberOfLines: 0)
        
        uploadingView = .init(name: "uploading")
        uploadingView?.loopMode = .loop
        uploadingView?.play()
        uploadingView?.contentMode = .scaleAspectFit
        uploadingView?.backgroundColor = .black
        uploadingView?.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.addSubview(uploadingView ?? UIView(backgroundColor: .black))
        uploadingView?.anchor(top: animationView.topAnchor, leading: animationView.leadingAnchor, bottom: animationView.bottomAnchor, trailing: animationView.trailingAnchor, padding: .init(top: 150, left: 150, bottom: 150, right: 150))

        animationView.addSubview(uploadingLabel)
        uploadingLabel.anchor(top: nil, leading: animationView.leadingAnchor, bottom: animationView.bottomAnchor, trailing: animationView.trailingAnchor, padding: .init(top: 0, left: 150, bottom: 150, right: 150))

        view.addSubview(animationView)
        animationView.fillSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = previewRoundedView.layer.bounds
        previewRoundedView.layer.addSublayer(previewLayer)
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
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                backInput = input
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
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                frontInput = input
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
            } catch {
                print("Failed to setup camera")
            }
        }
    }
    
    fileprivate func setupView() {
        view.backgroundColor = .black
        
        view.addSubview(previewRoundedView)
        
        view.addSubview(shutterButton)
        let bottomPadding = view.frame.height - previewRoundedView.frame.height - previewRoundedView.frame.minY
        shutterButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 100, right: 0), size: .init(width: 80, height: 80))
        shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(switchCameraButton)
        let leftPadding = (view.frame.width/4) - (shutterButton.frame.width) - 35
        switchCameraButton.anchor(top: nil, leading: shutterButton.trailingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: leftPadding, bottom: 120, right: 0), size: .init(width: 35, height: 35))
        
        view.addSubview(retakeButton)
        retakeButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 120, right: 15), size: .init(width: 0, height: 50))
    }
    
    @objc fileprivate func switchCameraButtonPressed() {
        switchCameraButton.isUserInteractionEnabled = false
        
        session?.beginConfiguration()
        guard let backInput = backInput, let frontInput = frontInput else {return}
        if backCameraOn {
            session?.removeInput(backInput)
            session?.addInput(frontInput)
            backCameraOn = false
        } else {
            session?.removeInput(frontInput)
            session?.addInput(backInput)
            backCameraOn = true
        }
        
        session?.commitConfiguration()
        switchCameraButton.isUserInteractionEnabled = true
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
        shutterButton.isHidden = true
        switchCameraButton.isHidden = true
        
        if !backCameraOn {
            switchCameraButtonPressed()
        }

        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
        switchToFrontAndWait {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }
    
    fileprivate func switchToFrontAndWait(completion: @escaping () -> Void) {
        session?.beginConfiguration()
        guard let backInput = backInput, let frontInput = frontInput else {return}
        session?.removeInput(backInput)
        session?.addInput(frontInput)
        backCameraOn = false
        session?.commitConfiguration()
        
        // Wait for 0.1 second for the front camera to be ready to capture
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        // this is the image from the camera
        let image = UIImage(data: data)
        
        guard let backImage = backImage else {
            backImage = image
            return
        }
        
        frontImage = image
        isBothImageCaptured = true
        
        let meal = Meal(authorUsername: currUser.username, authorProfilePicture: currUser.profileImageURL, privateData: PrivateData(authorUserID: currUser.authID)) //<---- TODO: add profile picture later
        
        // display captured images
        let containerView = PreviewPhotoContainerView()
        containerView.meal = meal
        containerView.backImageView.image = backImage
        containerView.frontImageView.image = frontImage
        view.addSubview(containerView)
        containerView.anchor(top: previewRoundedView.topAnchor, leading: previewRoundedView.leadingAnchor, bottom: previewRoundedView.bottomAnchor, trailing: previewRoundedView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: previewRoundedView.frame.width, height: previewRoundedView.frame.height))
        containerView.layer.masksToBounds = true
        
        // save containerView to the previewContainerView to handle when the user pressed retake
        previewContainerView = containerView
        
        retakeButton.isHidden = false
    }
}
