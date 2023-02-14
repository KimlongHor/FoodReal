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
    let db = Firestore.firestore()
    let mealsRef = "Meals"
    let orderMealsBy = "dateTime"
    
    var query: Query!
    var documents = [QueryDocumentSnapshot]()
    var mealArray = [Meal]()
    
    init() {
    }
    
    func add(aPublicMeal meal: Meal) {
        var ref: DocumentReference? = nil
        ref = db.collection(mealsRef).addDocument(data: meal.getMealDocumentData()) {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func get(allPublicMeals meal: Meal) {
        let first = db.collection(mealsRef)
            .order(by: orderMealsBy)
            .limit(to: 5)
        
        let listener = first.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreving meals: \(error.debugDescription)")
                return
            }

            guard let lastSnapshot = snapshot.documents.last else {
                // The collection is empty.
                return
            }

            // Construct a new query starting after this document,
            // retrieving the next 25 cities.
            let next = self.db.collection(self.mealsRef)
                .order(by: self.orderMealsBy)
                .start(afterDocument: lastSnapshot)

            // Use the query for pagination.
            // ...
        }
    
        // detatch listener
        listener.remove();
    }
    
    func getData() {
        query = db.collection(mealsRef)
            .order(by: orderMealsBy, descending: true)
            .limit(to: 5)
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data() as [String: Any]
//                    let mealItem = Meal(authorUsername: data["authorUsername"] as! String,
//                                        authorProfileImageURL: data["authorProfilePicture"] as! String,
//                                        dateTime: data["dateTIme"] as! Date,
//                                        description: data["description"] as! String,
//                                        likes: data["likes"] as! [String],
//                                        frontImageURL: data["frontImage"] as! String,
//                                        backImageURL: data["backImage"] as! String,
//                                        userID: "tempuseridBecause SubscriptError")
////                                        userID: data["privateData"]?["authorUserID"] as! String)
//                    self.mealArray += [mealItem]
//                    self.documents += [document]
                    print(document.documentID);
                }
            }
        }
    }

    func paginate() {
        //This line is the main pagination code.
        //Firestore allows you to fetch document from the last queryDocument
        query = query.start(afterDocument: documents.last!)
        getData()
    }
}

