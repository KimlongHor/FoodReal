//
//  User.swift
//  FoodReal
//
//  Created by Yunseo Han on 3/7/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User : Codable {
    @DocumentID var uid: String?
    var authID: String?
    var name: String?
    var email: String?
    var username: String?
    var birthYear: String?
    var birthMonth: String?
    var birthDay: String?
    var profileImageURL: String?
}
