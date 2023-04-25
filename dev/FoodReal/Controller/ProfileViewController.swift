//
//  ProfileViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 4/9/23.
//

import UIKit

enum ActionOption: Int {
    case PhotoLibrary = 0, Camera, Cancel
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var cameraContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var currUser: User
    
    init?(coder: NSCoder, currUser: User) {
        self.currUser = currUser
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    fileprivate func setupView() {
        profileImageView.backgroundColor = .orange
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.createRoundCorner(cornerRadius: profileImageView.frame.height / 2)
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(setGestureRecognizerForProfileImageEditting())
        
        cameraImageView.backgroundColor = .white
        cameraImageView.createRoundCorner(cornerRadius: cameraImageView.frame.height / 2)
        cameraContainerView.createRoundCorner(cornerRadius: cameraContainerView.frame.height / 2)
        cameraContainerView.createBorder(color: .black, width: 2)
        cameraContainerView.isUserInteractionEnabled = true
        cameraContainerView.addGestureRecognizer(setGestureRecognizerForProfileImageEditting())
        
        title = "Edit Profile"
        fullNameTextField.backgroundColor = .black
        fullNameTextField.textColor = .white
        usernameTextField.backgroundColor = .black
        usernameTextField.textColor = .white
        emailTextField.backgroundColor = .black
        emailTextField.textColor = .white
        birthDateTextField.backgroundColor = .black
        birthDateTextField.textColor = .white
        
        fullNameTextField.text = currUser.username
        usernameTextField.text = currUser.username
        emailTextField.text = currUser.email
        birthDateTextField.text = "\(currUser.birthMonth!)/\(currUser.birthDay!)/\( currUser.birthYear!)"
        
        saveButton.createRoundCorner(cornerRadius: 10)
    }
    
    fileprivate func setGestureRecognizerForProfileImageEditting() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setupActionSheet))
        return tapGestureRecognizer
    }
    
    @objc fileprivate func setupActionSheet() {
        var actions: [(String, UIAlertAction.Style)] = []
        actions.append(("Photo Library", UIAlertAction.Style.default))
        actions.append(("Camera", UIAlertAction.Style.default))
        actions.append(("Cancel", UIAlertAction.Style.cancel))
        
        Alerts.showActionsheet(viewController: self, title: "Change Profile Picture", message: "Your Profile Picture will be visible to everyone and it will make it easier for your friends to add you", actions: actions) {[weak self] (index) in
            switch index {
            case ActionOption.PhotoLibrary.rawValue:
                self?.openPhotoLibrary()
            case ActionOption.Camera.rawValue:
                #if targetEnvironment(simulator)
                    self?.view.presentPopUp(with: "Not available on simulators")
                #else
                    self?.openCamera()
                #endif
            case ActionOption.Cancel.rawValue:
                print("3")
            default:
                print("Default")
            }
        }
    }
    
    fileprivate func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    fileprivate func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("I am here")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated:true, completion: nil)
    }
}
