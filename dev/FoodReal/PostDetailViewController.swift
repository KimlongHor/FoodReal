//
//  PostDetailViewController.swift
//  FoodReal
//
//  Created by Yunseo Han on 4/25/23.
//

import UIKit
import LBTATools


class PostDetailViewController: UIViewController, UIScrollViewDelegate {
    
    let currMeal: Meal
    
    init(meal: Meal) {
        self.currMeal = meal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .black
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let swipingPostPreviewController = SwipingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    lazy var likedProfiles: UIStackView = {
        let profileStack = UIStackView()
        profileStack.axis = .horizontal
        profileStack.backgroundColor = .red
        profileStack.spacing = 10
        profileStack.addArrangedSubview(profile)
        return profileStack
    }()
    
    let profile: UIImageView = {
        let profile = UIImageView(image: UIImage(named: "cat"))
        profile.constrainWidth(80)
        profile.constrainHeight(80)
        profile.contentMode = .scaleAspectFill
        profile.clipsToBounds = true
        return profile
    }()
    
    lazy var desc: UITextView = {
        let desc = UITextView()
        desc.backgroundColor = .gray
        desc.text = ""
        desc.isScrollEnabled = false
        desc.createRoundCorner(cornerRadius: 5)
        return desc
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        button.constrainHeight(50)
//        button.addTarget(self, action: #selector(), for: .touchUpInside)
        return button
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = scrollView.contentOffset.y
        if (changeY < 100 && changeY > -100) {
            swipingPostPreviewController.view.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.width-changeY)
        }
    }
    
    func setUpImageScroll() {
        var controllers: [PhotoContoller] = []
        if let frontUrl = URL(string: currMeal.frontImageURL ?? "") {
            let imageData = try! Data(contentsOf: frontUrl)
            let image = UIImage(data: imageData) ?? UIImage(named: "food1")!
            controllers.append(PhotoContoller(image: image))
        }
        
        if let backUrl = URL(string: currMeal.backImageURL ?? "") {
            let imageData = try! Data(contentsOf: backUrl)
            let image = UIImage(data: imageData) ?? UIImage(named: "food2")!
            controllers.append(PhotoContoller(image: image))
        }
        swipingPostPreviewController.setControllers(newControllers: controllers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        let imageView = swipingPostPreviewController.view!
        scrollView.addSubview(imageView)
        swipingPostPreviewController.view.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.width)
        setUpImageScroll()
        
        scrollView.addSubview(desc)
        desc.anchor(top: imageView.bottomAnchor, leading: view.leadingAnchor, bottom:nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 15, bottom: 15, right: 15))
        scrollView.addSubview(saveButton)
        saveButton.anchor(top: desc.bottomAnchor, leading: view.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 30, left: 15, bottom: 500, right: 15))
        
        
        
//        liked profiles
//
//        scrollView.addSubview(likedProfiles)
//        likedProfiles.anchor(top: imageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
//        likedProfiles.constrainHeight(80)
        
//        addConstraints()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let imageView = swipingPostPreviewController.view!
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    }
    
    
    private func addConstraints() {
        if #available(iOS 15.0, *) {
            NSLayoutConstraint.activate([
                desc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                desc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 15),
                desc.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: 15)
            ])
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleSave() {
        FirebaseDB.updateDescription(meal: currMeal, description: desc.description) { error in
           print("Failed to update Description")
        }
    }
}
