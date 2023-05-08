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
    
//    let imageView: UIImageView = {
//        let iv = UIImageView(image: UIImage(named: "food1"))
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        return iv
//    }()
    
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
        desc.text = "jojoj"
        desc.isScrollEnabled = false
        return desc
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = scrollView.contentOffset.y
        swipingPostPreviewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width - changeY, height: view.frame.width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        let imageView = swipingPostPreviewController.view!
        scrollView.addSubview(imageView)
        scrollView.addSubview(desc)
//        desc.anchor(top: imageView.bottomAnchor, leading: view.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 30, left: 15, bottom: 15, right: 15))
        
        
        
//        liked profiles
//
//        scrollView.addSubview(likedProfiles)
//        likedProfiles.anchor(top: imageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
//        likedProfiles.constrainHeight(80)
        
        addConstraints()
        
        // create round corners
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
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
    
    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
}
