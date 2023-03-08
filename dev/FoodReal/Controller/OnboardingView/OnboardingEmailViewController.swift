//
//  OnboardingEmailViewController.swift
//  FoodRealPlayground
//
//  Created by Yunseo Han on 2/28/23.
//

import UIKit

class OnboardingEmailViewController: UIViewController {
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
        header.backgroundColor = .systemRed
        return header
    }()
    
    private let instruction: UILabel = {
        let instruction = UILabel()
        instruction.translatesAutoresizingMaskIntoConstraints = false
        instruction.text = "Create your account using your email"
        instruction.textColor = .white
        instruction.font = UIFont.boldSystemFont(ofSize: 16)
        instruction.textAlignment = .center
        return instruction
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.textColor = .white
        emailField.font = UIFont.boldSystemFont(ofSize: 40)
        emailField.textAlignment = .center
        emailField.backgroundColor = .systemPink
        emailField.placeholder = "Your email"
        emailField.adjustsFontSizeToFitWidth = true
        emailField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return emailField
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
                emailField.topAnchor.constraint(equalTo: instruction.bottomAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.height/40),
                emailField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
                emailField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
                emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
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
        view.addSubview(emailField)
        view.addSubview(continueButton)
        
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside) // does not work if I call didTapContinueButton() aka with parenthesis
        addConstraints()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc fileprivate func handleTextInputChange() {
        let emailIsEntered = emailField.text?.count ?? 0 > 0
        if (emailIsEntered) {
            continueButton.isEnabled = true
            continueButton.backgroundColor = .white
        } else {
            continueButton.isEnabled = false
            continueButton.backgroundColor = .systemGray
        }
    }
    
    
    @objc func didTapContinueButton() {
        newUser.email = emailField.text!
        let onboardingUsernameViewController = OnboardingUsernameViewController(user: newUser)
        onboardingUsernameViewController.modalPresentationStyle = .fullScreen
        onboardingUsernameViewController.modalTransitionStyle = .crossDissolve
        present(onboardingUsernameViewController, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
