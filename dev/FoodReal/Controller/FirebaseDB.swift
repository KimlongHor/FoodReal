//
//  FirebaseDB.swift
//  FoodReal
//
//  Created by Yunseo Han on 2/12/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FirebaseDB {
    static let db = Firestore.firestore()
    static let mealsRef = "Meals"
    static let dateTimeField = "dateTime"
        
    static func add(aPublicMeal meal: Meal) {
        var ref: DocumentReference? = nil
        do {
            ref = try db.collection(mealsRef).addDocument(from: meal) {
                err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        } catch {
            print(error)
        }
    }
}

