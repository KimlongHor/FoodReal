//
//  FirebaseDB.swift
//  FoodReal
//
//  Created by Yunseo Han on 2/12/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FirebaseDB {
    static let db = Firestore.firestore()
    static let mealsRef = "Meals"
    static let dateTimeField = "dateTime"
        
    static func add(aPublicMeal meal: Meal, completion: @escaping((String?, Error?) -> ())) {
        var ref: DocumentReference? = nil
        do {
            ref = try db.collection(mealsRef).addDocument(from: meal) {
                err in
                if let err = err {
                    completion(nil, err)
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    completion("Successfully added to the database", nil)
                }
            }
        } catch {
            print(error)
        }
    }
    
  static func signOut() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    static func getData(lastDocSnapShot: DocumentSnapshot?, completion: @escaping(([Meal]?, DocumentSnapshot?, Error?) -> ())) {
        var query: Query!
        var newLastDocSnapshot: DocumentSnapshot?

        var meals: [Meal]? {
            didSet {
                completion(meals, newLastDocSnapshot, nil)
            }
        }
        
        if let lastDocSnapShot = lastDocSnapShot {
            query = db.collection(mealsRef).order(by: dateTimeField, descending: true).start(afterDocument: lastDocSnapShot).limit(to: 2)
            print("Next 2 is loaded")
        } else {
            query = db.collection(mealsRef).order(by: dateTimeField, descending: true).limit(to: 2)
            print("First 2 doc")
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, nil, error)
            } else if snapshot!.isEmpty {
                print("Empty snapshot")
                completion(nil, nil, nil)
                return
            } else {
                meals = snapshot?.documents.compactMap({ queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: Meal.self) }
                    switch result {
                    case .success(let meal):
                        print(meal.id!)
                        newLastDocSnapshot = snapshot?.documents.last
                        return meal
                    case .failure(let error):
                        fatalError("Failed to decode fetched meal data \(error.localizedDescription)")
                        return nil
                    }
                })
            }
        }
    }
}

