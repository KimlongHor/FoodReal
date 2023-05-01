//
//  PostDetailViewController.swift
//  FoodReal
//
//  Created by Yunseo Han on 4/25/23.
//

import UIKit
import LBTATools

class PostDetailViewController: UIViewController, UIScrollViewDelegate{

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .black
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "food1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    } ()
    
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
    
    let desc: UITextView = {
        let desc = UITextView()
        desc.backgroundColor = .gray
        desc.text = "jojoj"
        desc.isScrollEnabled = false
        return desc
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = scrollView.contentOffset.y
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width - changeY, height: view.frame.width)
        
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        scrollView.addSubview(likedProfiles)
        likedProfiles.anchor(top: imageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        likedProfiles.constrainHeight(80)
        
        
        scrollView.addSubview(desc)
        desc.anchor(top: likedProfiles.bottomAnchor, leading: view.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        // create round corners
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
