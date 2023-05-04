//
//  OnboardingBirthdayViewController.swift
//  FoodRealPlayground
//
//  Created by Yunseo Han on 2/28/23.
//

import UIKit
import LBTATools

class OnboardingBirthdayViewController: UIViewController {
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
        instruction.text = "Hi, when's your birthday?"
        instruction.textColor = .white
        instruction.font = UIFont.boldSystemFont(ofSize: 16)
        instruction.textAlignment = .center
        return instruction
    }()
    
    private let monthField: UITextField = {
        let month = UITextField()
        month.textColor = .white
        month.font = UIFont.boldSystemFont(ofSize: 40)
        month.textAlignment = .left
        month.attributedPlaceholder = NSAttributedString(
            string: "MM",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        month.contentMode = .scaleAspectFit
        month.keyboardType = .decimalPad
        month.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return month
    }()
    
    private let dayField: UITextField = {
        let day = UITextField()
        day.textColor = .white
        day.font = UIFont.boldSystemFont(ofSize: 40)
        day.textAlignment = .left
        day.attributedPlaceholder = NSAttributedString(
            string: "DD",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        day.contentMode = .scaleAspectFit
        day.keyboardType = .decimalPad
        day.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return day
    }()
    
    private let yearField: UITextField = {
        let year = UITextField()
        year.textColor = .white
        year.font = UIFont.boldSystemFont(ofSize: 40)
        year.textAlignment = .left
        year.attributedPlaceholder = NSAttributedString(
            string: "YYYY",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        year.contentMode = .scaleAspectFit
        year.keyboardType = .decimalPad
        year.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return year
    }()
    
    private func setupDateField() {
        let date = UIStackView();
        date.translatesAutoresizingMaskIntoConstraints = false
        date.addArrangedSubview(monthField)
        date.addArrangedSubview(dayField)
        date.addArrangedSubview(yearField)
        date.spacing = 10
        
        view.addSubview(date);
        date.anchor(top: instruction.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
        date.centerXToSuperview()
    }
    
    private func setupInstruction() {
        instruction.text = "Hi \(newUser.name ?? ""), when's your birthday?"
        view.addSubview(instruction)
    }
    
    
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
        setupInstruction()
        setupDateField()
        view.addSubview(continueButton)
        
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside) // does not work if I call didTapContinueButton() aka with parenthesis
        addConstraints()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @objc fileprivate func handleTextInputChange() {
        let dayIsValid = dayField.text?.count ?? 0 == 2
        let monthIsValid = monthField.text?.count ?? 0 == 2
        let yearIsValid = yearField.text?.count ?? 0 == 4
        if (dayIsValid && monthIsValid && yearIsValid) {
            continueButton.isEnabled = true
            continueButton.backgroundColor = .white
        } else {
            continueButton.isEnabled = false
            continueButton.backgroundColor = .systemGray
        }
    }
    
    
    @objc func didTapContinueButton() {
        newUser.birthYear = yearField.text!
        newUser.birthMonth = monthField.text!
        newUser.birthDay = dayField.text!
        let onboardingEmailViewController = OnboardingEmailViewController(user: self.newUser)
        onboardingEmailViewController.modalPresentationStyle = .fullScreen
        onboardingEmailViewController.modalTransitionStyle = .crossDissolve
        present(onboardingEmailViewController, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
