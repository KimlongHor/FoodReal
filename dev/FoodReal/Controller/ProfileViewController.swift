//
//  ProfileViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 4/9/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    
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
        profileImageView.createRoundCorner(cornerRadius: profileImageView.frame.height / 2)
        
        cameraImageView.backgroundColor = .white
        cameraImageView.createRoundCorner(cornerRadius: cameraImageView.frame.height / 2)
        cameraImageView.createBorder(color: .black, width: 2)
        
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
    }
}
