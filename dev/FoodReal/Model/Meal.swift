//
//  Meal.swift
//  FoodReal
//
//  Created by Yunseo Han on 2/12/23.
//

import Foundation

struct Meal : Codable{
    private let authorUsername: String
    private var authorProfileImageURL: String
    private let dateTime: Date
    private var description: String
    private var likes: [String]
    private let frontImageURL: String
    private let backImageURL: String
    private let userID: String
    
    
    func getMealDocumentData() -> [String: Any] {
        return [
            "authorUsername" : authorUsername,
            "authorProfilePicture" : authorProfileImageURL,
            "dateTime" : dateTime,
            "description" : description,
            "likes" : likes,
            "frontImage" : frontImageURL,
            "backImage" : backImageURL,
            "privateData" : [
                "authorUserID" : userID
            ]
        ]
    }
}
