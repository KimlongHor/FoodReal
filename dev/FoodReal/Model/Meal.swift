//
//  Meal.swift
//  FoodReal
//
//  Created by Yunseo Han on 2/12/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Meal : Codable {
    @DocumentID var id: String?
    var authorUsername: String
    var authorProfilePicture: String
    @ServerTimestamp var dateTime: Date?
    var description: String
    var likes: [String]
    var frontImage: Data?
    var backImage: Data?
    var privateData: PrivateData
}

struct PrivateData : Codable {
    var authorUserID: String
}
