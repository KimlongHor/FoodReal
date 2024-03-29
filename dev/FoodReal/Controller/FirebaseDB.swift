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
import FirebaseStorage

class FirebaseDB {
    static let db = Firestore.firestore()
    static let mealsRef = "Meals"
    static let usersRef = "Users"
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let onboardingNameViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingNameViewController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(onboardingNameViewController)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    static func add(aNewUser user: User, completion: @escaping((String?, Error?) -> ())) {
        var ref: DocumentReference? = nil
        do {
            ref = try db.collection(usersRef).addDocument(from: user) {
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
    
    static func getUserProfile(authID: String, completion: @escaping((User?, Error?) -> ())) {
        let query = db.collection(usersRef).whereField("authID", isEqualTo: authID)
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
            } else if snapshot!.isEmpty {
                print("No matching user profile found")
                completion(nil, nil)
            } else {
                do {
                    for document in snapshot!.documents {
                        let user: User = try document.data(as: User.self)
                        print("\(document.documentID) => \(document.data())")
                        completion(user, error)
                    }
                } catch {
                    print("Error occurred while loading document from snapshot")
                    completion(nil, nil)
                }
            }
        }
        return
    }
    
    static func updateAuthorInfoOnMeals(authID: String, authProfileImageURL: String, authUsername: String, completion: @escaping((String?, Error?) -> ())) {
        let query = db.collection(mealsRef).whereField("privateData.authorUserID", isEqualTo: authID)
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
            } else if snapshot!.isEmpty {
                completion("This user does not have any posts. No document gets updated", nil)
            } else {
                do {
                    for document in snapshot!.documents {
                        print("HERE \(document.documentID) -> \(document.data())")
                        db.collection(mealsRef).document(document.documentID).updateData([
                            "authorProfilePicture" : authProfileImageURL,
                            "authorUsername" : authUsername
                        ])
                    }
                    completion("Finished uploading user images in meal documents", nil)
                } catch {
                    print("Error occurred while loading document from snapshot - updateAuthoInfoOnMeals func")
                    completion(nil, nil)
                }
            }
        }
    }
    
    static func addLike(to meal: Meal?, likedUser: User?, completion:@escaping (_ error: Error?) -> ()) {
        guard let meal = meal, let likedUser = likedUser else {
            print("Invalid meal and user")
            return
        }
        db.collection(mealsRef).document(meal.id!).updateData(["likes": FieldValue.arrayUnion([likedUser.uid!])]) { error in
            completion(error)
        }
    }
    
    static func removeLike(to meal: Meal?, likedUser: User?, completion:@escaping (_ error: Error?) -> ()) {
        guard let meal = meal, let likedUser = likedUser else {
            print("Invalid meal and user")
            return
        }
        db.collection(mealsRef).document(meal.id!).updateData(["likes": FieldValue.arrayRemove([likedUser.uid!])]) { error in
            completion(error)
        }
    }
    
    static func saveImageToFirebase(imageView: UIImageView, completion: @escaping (_ url: String)->()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        ref.putData(imageView.image?.jpegData(compressionQuality: 0.3) ?? Data(), metadata: nil) { (_, error) in
            if let error = error {
                print("cannot save image to Firebase", error)
                return
            }
            print("finish upload of image")
            ref.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("cannot get url of image", error)
                    return
                }
                let imageURL = url?.absoluteString ?? ""
                completion(imageURL)
            })
        }
    }
    
    static func updateUserProfile(user: User?, completion:@escaping (_ error: Error?) -> ()) {
        guard let user = user else {
            print("Invalid user")
            return
        }
        
        guard let name = user.name, let username = user.username else {return}
        
        db.collection(usersRef).document(user.uid!).updateData([
            "profileImageURL" : user.profileImageURL ?? "",
            "name" : name,
            "username" : username
        ]) { error in
            completion(error)
        }
    }
}

