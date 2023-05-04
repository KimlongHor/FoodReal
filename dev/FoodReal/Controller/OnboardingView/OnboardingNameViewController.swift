//
//  OnboardingNameViewController.swift
//  FoodRealPlayground
//
//  Created by Yunseo Han on 2/27/23.
//

import UIKit

class OnboardingNameViewController: UIViewController {
    
    
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
        instruction.text = "What's your name?"
        instruction.textColor = .white
        instruction.font = UIFont.boldSystemFont(ofSize: 16)
        instruction.textAlignment = .center
        return instruction
    }()
    
    private let nameField: UITextField = {
        let nameField = UITextField()
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.textColor = .white
        nameField.font = UIFont.boldSystemFont(ofSize: 40)
        nameField.textAlignment = .center
//        nameField.placeholder = "Your name"
        nameField.attributedPlaceholder = NSAttributedString(
            string: "Your name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        nameField.adjustsFontSizeToFitWidth = true
        nameField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        nameField.autocorrectionType = .no
        return nameField
    }()
    
    private let signInButton: UIButton = {
        let signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.setTitleColor(.systemBlue, for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return signInButton
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
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
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
                
                // name field
                nameField.topAnchor.constraint(equalTo: instruction.bottomAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.height/40),
                nameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
                nameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
                nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                
                //continue button
                continueButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -15),
                continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                continueButton.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height/15),
                continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                //sign on button
                signInButton.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -10),
                signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Onboarding name"
        
        view.backgroundColor = .black
        // Do any additional setup after loading the view.
        view.addSubview(header)
        view.addSubview(instruction)
        view.addSubview(nameField)
        view.addSubview(continueButton)
        view.addSubview(signInButton)
        
        addConstraints()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc fileprivate func handleTextInputChange() {
        let nameIsEntered = nameField.text?.count ?? 0 > 0
        continueButton.isEnabled = nameIsEntered
        if (nameIsEntered) {
            continueButton.backgroundColor = .white
        } else {
            continueButton.backgroundColor = .systemGray
        }
    }

    @objc fileprivate func didTapContinueButton() {
        let newUser = User(name: nameField.text)
        let onboardingBirthdayViewController = OnboardingBirthdayViewController(user: newUser)
        onboardingBirthdayViewController.modalPresentationStyle = .fullScreen
        onboardingBirthdayViewController.modalTransitionStyle = .crossDissolve
        present(onboardingBirthdayViewController, animated: true)
    }
    
    @objc fileprivate func didTapSignInButton() {
        let signInEmailViewController = SignInEmailViewController()
        signInEmailViewController.modalPresentationStyle = .fullScreen
        signInEmailViewController.modalTransitionStyle = .crossDissolve
        present(signInEmailViewController, animated: true)
    }
}
