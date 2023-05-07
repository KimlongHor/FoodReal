//
//  NotificationViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 5/7/23.
//

import Foundation
import UIKit

class NotificationViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        title = "Notification"
        setupView()
    }
    
    fileprivate func setupView() {
        let instructionLabel = UILabel(text: "To enable to disable the notificaiton: ", font: .systemFont(ofSize: 20), textColor: .white, textAlignment: .center, numberOfLines: 0)
        
        let pathLabel = UILabel(text: "Setting > FoodReal > Notifications", font: .systemFont(ofSize: 22, weight: .semibold), textColor: .white, textAlignment: .center, numberOfLines: 0)
        
        let defaultNotiLabel = UILabel(text: "If allowed, you will receive 3 notifications per day at 8:00 am, 12:00 pm, and 6:00 pm.*", font: .italicSystemFont(ofSize: 18), textColor: .white, textAlignment: .left, numberOfLines: 0)
        
        view.addSubview(instructionLabel)
        view.addSubview(pathLabel)
        view.addSubview(defaultNotiLabel)
        instructionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        pathLabel.anchor(top: instructionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        defaultNotiLabel.anchor(top: pathLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 12, bottom: 0, right: 12))
    }
    
}
