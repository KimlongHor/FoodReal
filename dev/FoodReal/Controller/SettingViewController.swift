//
//  SettingViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/15/23.
//

import UIKit

class SettingViewController: UIViewController {
    
    private let signOutButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 20
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSignOutButton()
    }

    fileprivate func setupView() {
        view.backgroundColor = .black
        title = "Settings"
    }
    
    fileprivate func setupSignOutButton() {
        view.addSubview(signOutButton)
        signOutButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 15, right: 10))
        signOutButton.centerXToSuperview()
        signOutButton.constrainHeight(view.safeAreaLayoutGuide.layoutFrame.height/15)
        signOutButton.addTarget(self, action: #selector(didTapSignOutButton), for: .touchUpInside)
    }
    
    @objc func didTapSignOutButton() {
        FirebaseDB.signOut()
        let onboardingNameViewController = OnboardingNameViewController()
        onboardingNameViewController.modalPresentationStyle = .fullScreen
        onboardingNameViewController.modalTransitionStyle = .crossDissolve
        present(onboardingNameViewController, animated: true)
    }
    
    
}
