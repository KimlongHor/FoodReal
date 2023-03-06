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
    
    static func getData(completion: @escaping(([Meal]?, Error?) -> ())) {
        var postWallQuery: Query!
        var meals: [Meal]? {
            didSet {
                completion(meals, nil)
            }
        }
        
        postWallQuery = FirebaseDB.db.collection(FirebaseDB.mealsRef)
            .order(by: FirebaseDB.dateTimeField, descending: true)
            .limit(to: 5)
        
        postWallQuery.getDocuments() {(querySnapshot, error) in
            if let error = error {
                print("Failed getting document from Meal collection: \(error.localizedDescription)")
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents in Meal collection")
                return
            }
            
            meals = documents.compactMap({ queryDocumentSnapshot in
                let result = Result { try queryDocumentSnapshot.data(as: Meal.self) }
                switch result {
                case .success(let meal):
                    print(meal.id!)
                    return meal
                case .failure(let error):
                    print("Failed to decode fetched meal data")
                    // A Meal value could not be initalized from the DocmentSnapshot.
//                    switch error {
//                    case DecodingError.typeMismatch(_, let context):
//                        self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
//                    case DecodingError.valueNotFound(_, let context):
//                        self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
//                    case DecodingError.keyNotFound(_, let context):
//                        self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
//                    case DecodingError.dataCorrupted(let key):
//                        self?.errorMessage = "\(error.localizedDescription): \(key)"
//                    default:
//                        self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
//                    }
                    return nil
                }
            })
        }
    }
}

