//
//  PreviewPhotoContainerView.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/24/23.
//

import Foundation
import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    var meal: Meal?
    
    let frontImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.createRoundCorner(cornerRadius: 18)
        iv.clipsToBounds = true
        iv.createBorder(color: .white, width: 2)
        return iv
    }()
    
    let backImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "save")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let postButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setImage(UIImage(named: "right-arrows")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.createRoundCorner(cornerRadius: 18)
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handlePost() {
        guard let meal = meal else {return}
        FirebaseDB.add(aPublicMeal: meal) { success, error in
            if let error = error {
                print("Failed to add to database: \(error.localizedDescription)")
                return
            }
            
            guard let successMessage = success else {return}
            print(successMessage)
            self.parentViewController?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createRoundCorner(cornerRadius: 15)
        
        addSubview(backImageView)
        backImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        
        addSubview(frontImageView)
        frontImageView.anchor(top: backImageView.topAnchor, leading: backImageView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 18, left: 18, bottom: 0, right: 0), size: .init(width: 100, height: 160))
        
        addSubview(saveButton)
        saveButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 20, bottom: 20, right: 0), size: .init(width: 0, height: 0))
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 20), size: .init(width: 75, height: 40))
    }
    
    @objc func handleSave() {
        print("Handling save...")
        
        guard let frontImage = frontImageView.image else { return }
        guard let backImage = backImageView.image else { return }
        
        let images: [UIImage] = [frontImage, backImage]
        saveToCameraRoll(images: images)
    }

    fileprivate func saveToCameraRoll(images: [UIImage]) {
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            
            for image in images {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }) { (success, err) in
            if let err = err {
                print("Failed to save image to photo library:", err)
                return
            }
            
            print("Successfully saved image to library")
            
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully"
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.textColor = .white
                savedLabel.numberOfLines = 0
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.textAlignment = .center
                
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.center = self.center
                
                self.addSubview(savedLabel)
                
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    
                }, completion: { (completed) in
                    //completed
                    
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                        
                    }, completion: { (_) in
                        
                        savedLabel.removeFromSuperview()
                        
                    })
                    
                })
            }
        }
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
