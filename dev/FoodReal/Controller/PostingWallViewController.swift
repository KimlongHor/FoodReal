//
//  ViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 1/31/23.
//
import UIKit
import FirebaseCore
import FirebaseFirestore

class PostingWallViewController: UIViewController {

    @IBOutlet weak var postCollectionView: UICollectionView!
    fileprivate var posts = ["1", "2", "3"]
    @Published var errorMessage: String?
    
    var postWallQuery: Query!
    var meals = [Meal]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPostCollectionView()
        getData()
    }
    
    fileprivate func setupPostCollectionView() {
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "PostCollectionViewCell")
    }
}

extension PostingWallViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath as IndexPath) as! PostCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = self.view.frame.height - self.view.frame.height/3.5
        return .init(width: width, height: height)
    }
    
    func getData() {
        postWallQuery = FirebaseDB.db.collection(FirebaseDB.mealsRef)
            .order(by: FirebaseDB.dateTimeField, descending: true)
            .limit(to: 5)
        
        postWallQuery.getDocuments() { [weak self] (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                self?.errorMessage = "No documents in Meals collection"
                return
            }

            self?.meals = documents.compactMap({ queryDocumentSnapshot in
                let result = Result { try queryDocumentSnapshot.data(as: Meal.self) }
                switch result {
                case .success(let meal):
                    self?.errorMessage = nil
                    print(meal.id!)
                    return meal
                case .failure(let error):
                    // A Meal value could not be initalized from the DocmentSnapshot.
                    switch error {
                    case DecodingError.typeMismatch(_, let context):
                        self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    case DecodingError.valueNotFound(_, let context):
                        self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    case DecodingError.keyNotFound(_, let context):
                        self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    case DecodingError.dataCorrupted(let key):
                        self?.errorMessage = "\(error.localizedDescription): \(key)"
                    default:
                        self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
                    }
                    return nil
                }
            })
        }
    }
    
//  TODO: IMPLEMENT PAGINATE -CLAIRE
//    func paginate() {
//        //This line is the main pagination code.
//        //Firestore allows you to fetch document from the last queryDocument
//        query = query.start(afterDocument: documents.last!)
//        getData()
//    }
}
