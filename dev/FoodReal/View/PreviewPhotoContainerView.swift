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
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createRoundCorner(cornerRadius: 15)
        
        addSubview(backImageView)
        backImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        
        addSubview(frontImageView)
        frontImageView.anchor(top: backImageView.topAnchor, leading: backImageView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 18, left: 18, bottom: 0, right: 0), size: .init(width: 100, height: 160))
        
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0), size: .init(width: 50, height: 50))
    }
    
    @objc fileprivate func handleCancel() {
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
