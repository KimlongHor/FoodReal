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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPostCollectionView()
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        // setup the navbar and textAttribute
        let label = UILabel()
        let titleAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 25), .foregroundColor: UIColor.white]
        let attributeString = NSMutableAttributedString(string: "FoodReal.", attributes: titleAttribute)

        label.attributedText = attributeString
        label.sizeToFit()
        navigationItem.titleView = label
        
        // add a button to the right of the navbar
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .done, target: self, action: #selector(didTapProfileButton))
        navigationController?.navigationBar.tintColor = .white
    }
    
    fileprivate func setupPostCollectionView() {
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "PostCollectionViewCell")
    }
    
    @objc func didTapProfileButton() {
        let desVC =  SettingViewController()
        navigationController?.pushViewController(desVC, animated: true)
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
}

/*
        // Add a new document with a generated ID
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
 */
