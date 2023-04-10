//
//  OnboardingPasswordViewController.swift
//  FoodRealPlayground
//
//  Created by Yunseo Han on 3/6/23.
//

import UIKit
import FirebaseAuth
import Lottie

class SignInPasswordViewController: UIViewController {
    private var email: String
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }

    private let header: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "FoodReal."
        header.textColor = .white
        header.font = UIFont.boldSystemFont(ofSize: 25);
        header.textAlignment = .center
        return header
    }()
    
    private let instruction: UILabel = {
        let instruction = UILabel()
        instruction.translatesAutoresizingMaskIntoConstraints = false
        instruction.text = "Enter your password"
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
//        passwordField.backgroundColor = .systemPink
        passwordField.placeholder = "Your password"
        passwordField.adjustsFontSizeToFitWidth = true
        passwordField.isSecureTextEntry = true
        passwordField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        return passwordField
    }()
    
    private let signInButton: UIButton = {
        let signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.backgroundColor = .gray
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        signInButton.layer.cornerRadius = 20
        signInButton.isEnabled = false
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return signInButton
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
                signInButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -15),
                signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                signInButton.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height/15),
                signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        view.addSubview(signInButton)
        
        addConstraints()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc fileprivate func handleTextInputChange() {
        let usernameIsEntered = passwordField.text?.count ?? 0 > 0
        if (usernameIsEntered) {
            signInButton.isEnabled = true
            signInButton.backgroundColor = .white
        } else {
            signInButton.isEnabled = false
            signInButton.backgroundColor = .systemGray
        }
    }
            
    
    @objc func didTapSignInButton() {
        Auth.auth().signIn(withEmail: self.email, password: self.passwordField.text!) { [weak self] authResult, error in
                guard self != nil else { return }   // what's the weak self for here? TODO: QUESTION
                if let error = error {
                    print("Failed to sign in user: \(error.localizedDescription)")
                    self?.presentPopUp(with: error.localizedDescription)
                    return
                }
                let postingWall = OnboardingNotificationViewController()
                postingWall.modalPresentationStyle = .fullScreen
                postingWall.modalTransitionStyle = .crossDissolve
                self!.present(postingWall, animated: true)
            }
    }
    
    fileprivate func presentPopUp(with message: String) {
        DispatchQueue.main.async {
            let savedLabel = UILabel()
            savedLabel.text = message
            savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
            savedLabel.textColor = .white
            savedLabel.numberOfLines = 0
            savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
            savedLabel.textAlignment = .center
            savedLabel.createRoundCornerForLabel(cornerRadius: 15)
            savedLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: 80)
            savedLabel.center = self.view.center
            
            self.view.addSubview(savedLabel)
            
            savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                
            }, completion: { (completed) in
                //completed
                
                UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                    savedLabel.alpha = 0
                    
                }, completion: { (_) in
                    
                    savedLabel.removeFromSuperview()
                    
                })
                
            })
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}