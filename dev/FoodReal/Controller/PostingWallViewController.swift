//
//  ViewController.swift
//  FoodReal
//
//  Created by Kimlong Hor on 1/31/23.
//
import UIKit
import FirebaseCore
import FirebaseFirestore
import Lottie

class PostingWallViewController: UIViewController {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    let refreshControl = UIRefreshControl()
    var loadingView: LottieAnimationView?
    var animationView = UIView(backgroundColor: .black) // we need this as a black background for loadingView
    var smileyView: LottieAnimationView?
    var meals: [Meal]? {
        didSet {
            postCollectionView.reloadData()
            animationView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimationViews()
        setupRefreshControl()
        setupPostCollectionView()
        setupNavBar()
    }
    
    fileprivate func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.backgroundColor = .clear
        refreshControl.addSubview(smileyView ?? UIView(backgroundColor: .white))
        smileyView?.anchor(top: refreshControl.topAnchor, leading: refreshControl.leadingAnchor, bottom: refreshControl.bottomAnchor, trailing: refreshControl.trailingAnchor)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        postCollectionView.refreshControl = refreshControl
    }
    
    fileprivate func setupAnimationViews() {
        loadingView = .init(name: "loading")
        loadingView?.loopMode = .loop
        loadingView?.play()
        loadingView?.contentMode = .scaleAspectFit
        loadingView?.backgroundColor = .black
        loadingView?.translatesAutoresizingMaskIntoConstraints = false
        animationView.addSubview(loadingView ?? UIView(backgroundColor: .black))
        loadingView?.anchor(top: animationView.topAnchor, leading: animationView.leadingAnchor, bottom: animationView.bottomAnchor, trailing: animationView.trailingAnchor, padding: .init(top: 100, left: 100, bottom: 100, right: 100))
        view.addSubview(animationView)
        animationView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        smileyView = .init(name: "smiley")
        smileyView?.loopMode = .loop
        smileyView?.play()
        smileyView?.contentMode = .scaleAspectFit
        smileyView?.backgroundColor = .black
        smileyView?.translatesAutoresizingMaskIntoConstraints = false
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
        
        // add a button to the left of the navbar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera.fill"), style: .done, target: self, action: #selector(didTapCameraButton))
    }
    
    fileprivate func setupPostCollectionView() {
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "PostCollectionViewCell")
        FirebaseDB.getData { meal, error in
            self.meals = meal
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        FirebaseDB.getData { meal, error in
            self.meals = meal
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func didTapProfileButton() {
        let settingVC =  SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func didTapCameraButton() {
        let cameraVC = CameraViewController()
        cameraVC.delegate = self
        navigationController?.pushViewController(cameraVC, animated: true)
    }
}

extension PostingWallViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath as IndexPath) as! PostCollectionViewCell
        if let meal = meals?[indexPath.row] {
            cell.setupCellView(meal: meal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = self.view.frame.height - self.view.frame.height/3.5
        return .init(width: width, height: height)
    }
}

extension PostingWallViewController: CameraViewDelegate {
    func didPost() {
        animationView.isHidden = false
        FirebaseDB.getData { meal, error in
            self.meals = meal
        }
    }
}

// TODO: -Kim
/*
 - After clicking the post button, bring the users back to the postingWall screen and refresh the collectionView.
 - Work on adding legit data to firestore (Currently, only front and back images are real in database)
 */

//  TODO: IMPLEMENT PAGINATE -CLAIRE
//    func paginate() {
//        //This line is the main pagination code.
//        //Firestore allows you to fetch document from the last queryDocument
//        query = query.start(afterDocument: documents.last!)
//        getData()
//    }
