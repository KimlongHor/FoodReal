//
//  SettingViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/15/23.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    fileprivate func setupView() {
        view.backgroundColor = .black
        title = "Settings"
    }
}
