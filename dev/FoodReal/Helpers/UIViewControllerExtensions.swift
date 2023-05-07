//
//  UIViewControllerExtensions.swift
//  FoodReal
//
//  Created by Kimlong Hor on 5/6/23.
//

import Foundation
import UIKit

extension UIViewController {
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}
