//
//  OnboardingPasswordViewController.swift
//  FoodRealPlayground
//
//  Created by Yunseo Han on 3/6/23.
//

import UIKit
import FirebaseAuth

class OnboardingPasswordViewController: UIViewController {
    private var newUser: User
    
    init(user: User) {
        self.newUser = user
        super.init(nibName: nil, bundle: nil)
    }

    private let header: UILabel = { // when do you create objects vs functions?
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "FoodReal."
        header.textColor = .white
        header.font = UIFont.boldSystemFont(ofSize: 25); //anything like attributed string?
        header.textAlignment = .center
        return header
    }()
    
    private let instruction: UILabel = {
        let instruction = UILabel()
        instruction.translatesAutoresizingMaskIntoConstraints = false
        instruction.text = "Next, create your password"
        instruction.textColor = .white
        instruction.font = UIFont.boldSystemFont(ofSize: 16)
        instruction.textAlignment = .center
        return instruction
    }()
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.textColor = .white
        passwordField.font = UIFont.boldSystemFont(ofSize: 40)
        passwordField.textAlignment = .center
        passwordField.backgroundColor = .systemPink
        passwordField.placeholder = "Your password"
        passwordField.adjustsFontSizeToFitWidth = true
        passwordField.isSecureTextEntry = true
        passwordField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        return passwordField
    }()
    
    private let continueButton: UIButton = {
        let continueButton = UIButton()
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.backgroundColor = .gray
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.black, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        continueButton.layer.cornerRadius = 20
        continueButton.isEnabled = false
        return continueButton
    }()
    
    private func addConstraints() {
        if #available(iOS 15.0, *) {
            NSLayoutConstraint.activate([
                // header
                header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                // instruction
                instruction.topAnchor.constraint(equalTo: header.bottomAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.height/25),
                instruction.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                // date field
                passwordField.topAnchor.constraint(equalTo: instruction.bottomAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.height/40),
                passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
                passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
                passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                //continue button
                continueButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -15),
                continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                continueButton.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height/15),
                continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else {
            // Fallback on earlier versions
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        // Do any additional setup after loading the view.
        view.addSubview(header)
        view.addSubview(instruction)
        view.addSubview(passwordField)
        view.addSubview(continueButton)
        
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside) // does not work if I call didTapContinueButton() aka with parenthesis
        addConstraints()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc fileprivate func handleTextInputChange() {
        let usernameIsEntered = passwordField.text?.count ?? 0 > 0
        if (usernameIsEntered) {
            continueButton.isEnabled = true
            continueButton.backgroundColor = .white
        } else {
            continueButton.isEnabled = false
            continueButton.backgroundColor = .systemGray
        }
    }
            
    
    @objc func didTapContinueButton() {
        Auth.auth().createUser(withEmail: newUser.email!, password: passwordField.text!) {
            authResult, error in
            if let error = error {
                print("Failed to create user: \(error.localizedDescription)")
            }
            self.newUser.authID = authResult?.user.uid
            print(self.newUser)
            FirebaseDB.add(aNewUser: self.newUser) { success, error in
                if let error = error {
                    print("Failed to add to database: \(error.localizedDescription)")
                    return
                }
                
                guard let successMessage = success else {return}
                print(successMessage)
            }
        }
        let postingWall = OnboardingNotificationViewController()
        postingWall.modalPresentationStyle = .fullScreen
        postingWall.modalTransitionStyle = .crossDissolve
        self.present(postingWall, animated: true)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
