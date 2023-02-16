//
//  UIViewExtensions.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/7/23.
//

import Foundation
import UIKit

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
