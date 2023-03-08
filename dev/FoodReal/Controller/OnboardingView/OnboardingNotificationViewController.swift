//
//  ViewController.swift
//  MyPlayground
//
//  Created by Yunseo Han on 2/25/23.
//

import UIKit
import LBTATools

class OnboardingNotificationViewController: UIViewController {
    
    private let pageTitle: UITextView = {
        let title = UITextView()
        title.text = "Set up \nnotificatons"
        title.translatesAutoresizingMaskIntoConstraints = false
        title.isEditable = false
        title.isScrollEnabled = false
        title.textColor = .white
        title.backgroundColor = .black
        title.font = UIFont.boldSystemFont(ofSize: 40)
        title.textAlignment = .center
        return title
    }()
    
    private let instruction: UITextView = {
        let instruction = UITextView()
        instruction.text = "Remind yourself to post meals by enabling notifications"
        instruction.translatesAutoresizingMaskIntoConstraints = false
        instruction.isEditable = false
        instruction.isScrollEnabled = false
        instruction.textColor = .white
        instruction.backgroundColor = .black
        instruction.font = UIFont.boldSystemFont(ofSize: 15) // where to save font size?
        instruction.textAlignment = .center
        return instruction
    }()
    
    private let popupHeading: UILabel = {
        let heading = UILabel()
        heading.translatesAutoresizingMaskIntoConstraints = false
        heading.text = "Please turn on Notifications"
        heading.textColor = .white
        heading.font = UIFont.boldSystemFont(ofSize: 16)
        heading.adjustsFontSizeToFitWidth = true
        heading.textAlignment = .center
//        heading.backgroundColor = .systemPink
        
        return heading
    }()
    
    private let popupSubHeading: UITextView = {
        let subHeading = UITextView()
        subHeading.translatesAutoresizingMaskIntoConstraints = false
        subHeading.text = "We will only notify you at the times you specify"
        subHeading.isEditable = false
        subHeading.isScrollEnabled = false
        subHeading.textColor = .white
        subHeading.backgroundColor = .black         // why isn't it transparent?
//        subHeading.textContainerInset = .zero
        subHeading.textAlignment = .center
        subHeading.font = UIFont.systemFont(ofSize: 13)
        return subHeading
    }()
    
    private let popupButtons: UIStackView = {
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.clipsToBounds = true
        buttonStack.backgroundColor = .gray
        buttonStack.spacing = 0.5
        buttonStack.distribution = .fillEqually
        let boldFont = UIFont.boldSystemFont(ofSize: 14)
        let font = UIFont.systemFont(ofSize: 14)
        let allowButton = UILabel()
        allowButton.text = "Allow"
        allowButton.font = boldFont
        allowButton.textColor = .white
        allowButton.backgroundColor = .systemBlue
        allowButton.textAlignment = .center
        let scheduleSummaryButton = UILabel()
        scheduleSummaryButton.text = "Allow in Scheduled Summary"
        scheduleSummaryButton.font = font
        scheduleSummaryButton.textColor = .white
        scheduleSummaryButton.textAlignment = .center
        scheduleSummaryButton.backgroundColor = .black
        let dontAllowButton = UILabel()
        dontAllowButton.text = "Don't allow"
        dontAllowButton.font = font
        dontAllowButton.textColor = .white
        dontAllowButton.backgroundColor = .black
        dontAllowButton.textAlignment = .center
        
        buttonStack.addArrangedSubview(allowButton)
        buttonStack.addArrangedSubview(scheduleSummaryButton)
        buttonStack.addArrangedSubview(dontAllowButton)
        
        
        return buttonStack
    }()
    
    private func setupPopupView() {
        let popupView = UIView()
        popupView.layer.borderColor = UIColor.white.cgColor
        popupView.clipsToBounds = true
        popupView.layer.borderWidth = 1
        popupView.layer.cornerRadius = 15
        
        popupView.addSubview(popupHeading)
        popupHeading.anchor(top: popupView.topAnchor, leading: popupView.leadingAnchor, bottom: nil, trailing: popupView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        
        popupView.addSubview(popupSubHeading)
        popupSubHeading.anchor(top: popupHeading.bottomAnchor, leading: popupView.leadingAnchor, bottom: nil, trailing: popupView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        
        popupView.addSubview(popupButtons)
        popupButtons.anchor(top: popupSubHeading.bottomAnchor, leading: popupView.leadingAnchor, bottom: popupView.bottomAnchor, trailing: popupView.trailingAnchor, size: .init(width: 250, height: 120))
        
        view.addSubview(popupView)
        popupView.centerXToSuperview()
        popupView.anchor(top: instruction.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: 250, height: 220))
    }
    
    private let continueButton: UIButton = {
        let continueButton = UIButton()
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.backgroundColor = .white
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.black, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        continueButton.layer.cornerRadius = 20
        return continueButton
    }()
    
    private func addConstraints() {
        if #available(iOS 15.0, *) {
            NSLayoutConstraint.activate([
                // pageTitle
                pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                // instruction
                instruction.topAnchor.constraint(equalTo: pageTitle.bottomAnchor),
                instruction.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width*0.95),
                instruction.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
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
        view.addSubview(pageTitle)
        view.addSubview(instruction)
        view.addSubview(continueButton)
        
        
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside) // does not work if I call didTapContinueButton() aka with parenthesis
        addConstraints()
        setupPopupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @objc func didTapContinueButton() {
        let postingWall = PostingWallViewController()
        postingWall.modalPresentationStyle = .fullScreen
        postingWall.modalTransitionStyle = .crossDissolve
        present(postingWall, animated: true)
    }
}

