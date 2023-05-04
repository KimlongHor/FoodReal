//
//  ProfileViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 4/9/23.
//

import UIKit
import SDWebImage

protocol ProfileViewDelegate {
    func didFinishUpdatingUserProfile(updatedCurrUser: User)
}

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
    
    var didChangeProfileImage = false
    var currUser: User
    var delegate: ProfileViewDelegate?
    
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
        
        if let url = URL(string: currUser.profileImageURL ?? "") {
            profileImageView.sd_setImage(with: url, placeholderImage: nil, options: .highPriority)
        }
        
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
        birthDateTextField.isUserInteractionEnabled = false
        
        fullNameTextField.text = currUser.name
        usernameTextField.text = currUser.username
        emailTextField.text = currUser.email
        emailTextField.isUserInteractionEnabled = false
        birthDateTextField.text = "\(currUser.birthMonth!)/\(currUser.birthDay!)/\( currUser.birthYear!)"
        
        saveButton.createRoundCorner(cornerRadius: 10)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
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
        if (isEmpty(textField: fullNameTextField)) {
            view.presentPopUp(with: "Invalid full name")
            return
        } else if (isEmpty(textField: usernameTextField)) {
            view.presentPopUp(with: "Invalid user name")
            return
        }
        
        self.currUser.name = self.fullNameTextField.text
        self.currUser.username = self.usernameTextField.text
        
        if (didChangeProfileImage) {
            FirebaseDB.saveImageToFirebase(imageView: profileImageView) { url in
                self.currUser.profileImageURL = url
                
                FirebaseDB.updateUserProfile(user: self.currUser) { error in
                    if let error = error {
                        print("Failed to update user \(error.localizedDescription)")
                        return
                    }
                    
                    FirebaseDB.updateAuthorInfoOnMeals(authID: self.currUser.authID ?? "", authProfileImageURL: url, authUsername: self.currUser.username ?? "") { success, error in
                        if let error = error {
                            print("Failed to update authorInfo in meal documents \(error.localizedDescription)")
                            return
                        }
                        self.delegate?.didFinishUpdatingUserProfile(updatedCurrUser: self.currUser)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            FirebaseDB.updateUserProfile(user: currUser) { error in
                if let error = error {
                    print("Failed to update user \(error.localizedDescription)")
                }
                
                FirebaseDB.updateAuthorInfoOnMeals(authID: self.currUser.authID ?? "", authProfileImageURL: self.currUser.profileImageURL ?? "", authUsername: self.currUser.username ?? "") { success, error in
                    if let error = error {
                        print("Failed to update authorInfo in meal documents \(error.localizedDescription)")
                        return
                    }
                    self.delegate?.didFinishUpdatingUserProfile(updatedCurrUser: self.currUser)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    fileprivate func isEmpty(textField: UITextField) -> Bool {
        guard let text = textField.text else {return true}
        if text.isEmpty {
            return true
        } else {
            return false
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("I am here")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
            didChangeProfileImage = true
        }
        dismiss(animated:true, completion: nil)
    }
}
