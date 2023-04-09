//
//  SettingViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/15/23.
//

import UIKit

struct Section {
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case profileCell(model: Profile)
    case settingCell(model: SettingsOption)
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let handle: (() -> Void)
}

// Might not use this struct later since we can use User struct
struct Profile {
    let profileImage: UIImage?
    let username: String
    let userId: String
    let handle: (() -> Void)
}

class SettingViewController: UIViewController {
    
    var currUser: User
    
    init(currUser: User) {
        self.currUser = currUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        settingTableView = UITableView(frame: .zero, style: .insetGrouped)
        settingTableView.backgroundColor = .black
        settingTableView.separatorStyle = .singleLine
        settingTableView.separatorColor = .darkGray
        settingTableView.separatorInset = .zero
        settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: .main), forCellReuseIdentifier: "settingCell")
        settingTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: .main), forCellReuseIdentifier: "profileCell")
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    fileprivate func configure() {
        settings.append(Section(title: "", options: [
            .profileCell(model: .init(profileImage: nil, username: currUser.username ?? "---", userId: currUser.email ?? "...", handle: {self.navigateToProfileViewController()}))
        ]))
        settings.append(Section(title: "FEATURES", options: [.settingCell(model: SettingsOption(title: "Memories", icon: UIImage(systemName: "calendar"), handle: {self.view.presentPopUp(with: "Coming soon")}))]))
        
        settings.append(Section(title: "SETTINGS", options: [
            .settingCell(model: SettingsOption(title: "Notifications", icon: UIImage(named: "notification"), handle: {})),
            .settingCell(model: SettingsOption(title: "Privacy", icon: UIImage(named: "privacy"), handle: {self.view.presentPopUp(with: "Coming soon")})),
            .settingCell(model: SettingsOption(title: "Time Zone: Americas", icon: UIImage(named: "time-zone"), handle: {self.view.presentPopUp(with: "Coming soon")})),
            .settingCell(model: SettingsOption(title: "Other", icon: UIImage(named: "other"), handle: {self.view.presentPopUp(with: "Coming soon")}))]))
        
        settings.append(Section(title: "ABOUT", options: [
            .settingCell(model: SettingsOption(title: "Share FoodReal", icon: UIImage(named: "share"), handle: {self.view.presentPopUp(with: "Coming soon")})),
            .settingCell(model: SettingsOption(title: "Rate FoodReal", icon: UIImage(named: "rate"), handle: {self.view.presentPopUp(with: "Coming soon")})),
            .settingCell(model: SettingsOption(title: "Help", icon: UIImage(named: "help"), handle: {self.view.presentPopUp(with: "Coming soon")})),
            .settingCell(model: SettingsOption(title: "About", icon: UIImage(named: "about"), handle: {self.view.presentPopUp(with: "Coming soon")}))]))
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
        // SWITCH VIEW CONTROLLER MOCVED TO SIGNOUT FUNCTION IN DBCLASS
    }
    
    fileprivate func navigateToProfileViewController() {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileViewController", creator: { coder in
            return ProfileViewController(coder: coder, currUser: self.currUser)
        })
        navigationController?.pushViewController(profileVC, animated: true)
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
        let modelType = settings[indexPath.section].options[indexPath.row]
        
        switch modelType.self {
        case .settingCell(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell
            cell.setupView(with: model)
            return cell
        case .profileCell(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
            cell.setupView(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelType = settings[indexPath.section].options[indexPath.row]
        switch modelType.self {
        case .settingCell(let model):
            model.handle()
        case .profileCell(let model):
            model.handle()
        }
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 25
        }
    }
}
