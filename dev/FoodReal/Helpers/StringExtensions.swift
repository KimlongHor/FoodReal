//
//  StringExtensions.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/14/23.
//

import Foundation
import UIKit

extension String {
    
    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
