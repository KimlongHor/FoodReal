//
//  UIViewExtensions.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/7/23.
//

import Foundation
import UIKit

// for User Interface
extension UIView {
    func createRoundCorner(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }

    func createRoundCornerForLabel(cornerRadius: CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func createSpecificRoundCorner(at mask: CACornerMask ,radius: CGFloat) {
        self.layer.maskedCorners = mask
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func createBorder(color: UIColor, width: CGFloat) {
       self.layer.borderColor = color.cgColor
       self.layer.borderWidth = width
    }
}

extension UIView {
    func presentPopUp(with message: String) {
        DispatchQueue.main.async {
            let savedLabel = UILabel()
            savedLabel.text = message
            savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
            savedLabel.textColor = .white
            savedLabel.numberOfLines = 0
            savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
            savedLabel.textAlignment = .center
            savedLabel.createRoundCornerForLabel(cornerRadius: 15)
            savedLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width - 50, height: 80)
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


extension UIView {
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
