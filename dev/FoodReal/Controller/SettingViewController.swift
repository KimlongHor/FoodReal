//
//  SettingViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/15/23.
//

import UIKit

struct Section {
    let title: String
    let options: [SettingOption]
}

struct SettingOption {
    let title: String
    let icon: UIImage?
    let handle: (() -> Void)
}


class SettingViewController: UIViewController {
    
    private var settingTableView: UITableView!
    
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
    
    var settings = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupTableView()
        setupView()
    }
    
    fileprivate func setupTableView() {
        settingTableView = UITableView()
        settingTableView.backgroundColor = .black
        settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: .main), forCellReuseIdentifier: "settingCell")
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    fileprivate func configure() {
        settings.append(Section(title: "FEATURES", options: [
                SettingOption(title: "Memories", icon: UIImage(systemName: "calendar"), handle: {})]))
        
        settings.append(Section(title: "SETTINGS", options: [
            SettingOption(title: "Notifications", icon: UIImage(systemName: "calendar"), handle: {}),
            SettingOption(title: "Privacy", icon: UIImage(systemName: "calendar"), handle: {}),
            SettingOption(title: "Time Zone: Americas", icon: UIImage(systemName: "calendar"), handle: {}),
            SettingOption(title: "Other", icon: UIImage(systemName: "calendar"), handle: {})]))
        
        settings.append(Section(title: "ABOUT", options: [
            SettingOption(title: "Share FoodReal", icon: UIImage(systemName: "calendar"), handle: {}),
            SettingOption(title: "Rate FoodReal", icon: UIImage(systemName: "calendar"), handle: {}),
            SettingOption(title: "Help", icon: UIImage(systemName: "calendar"), handle: {}),
            SettingOption(title: "About", icon: UIImage(systemName: "calendar"), handle: {})]))
    }

    fileprivate func setupView() {
        view.backgroundColor = .black
        title = "Settings"
        
        view.addSubview(settingTableView)
        settingTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        setupSignOutButton()
    }
    
    fileprivate func setupSignOutButton() {
        view.addSubview(signOutButton)
        signOutButton.anchor(top: settingTableView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 15, right: 10))
        signOutButton.centerXToSuperview()
        signOutButton.constrainHeight(view.safeAreaLayoutGuide.layoutFrame.height/15)
        signOutButton.addTarget(self, action: #selector(didTapSignOutButton), for: .touchUpInside)
    }
    
    @objc func didTapSignOutButton() {
        FirebaseDB.signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardingNameViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingNameViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(onboardingNameViewController)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = settings[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell
        cell.setupView(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = settings[indexPath.section].options[indexPath.row]
        model.handle()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = settings[section]
        return model.title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.darkGray
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
    }
}
