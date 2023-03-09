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
            resetupViewIfNeeded()
        }
    }
    
    var lastDocumentSnapshot: DocumentSnapshot!
    var fetchingMore = false
    
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
        
        // fetch the latest data and save it in the meals variable
        FirebaseDB.getData(lastDocSnapShot: nil) { meals, lastDoc, error in
            if let error = error {
                print("Failed fetching data \(error.localizedDescription)")
                return
            }
            self.lastDocumentSnapshot = lastDoc
            self.meals = meals
        }
    }
    
    fileprivate func resetupViewIfNeeded() {
        guard let meals = meals else {return}
        if !meals.isEmpty {
            postCollectionView.reloadData()
            animationView.isHidden = true
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        
        // reset all the data to the original state
        meals?.removeAll()
        lastDocumentSnapshot = nil
        fetchingMore = true
        
        // fecth the latest data and save it in the meals variable
        FirebaseDB.getData(lastDocSnapShot: lastDocumentSnapshot) { meals, lastDoc, error in
            if let error = error {
                print("Failed fetching data \(error.localizedDescription)")
                return
            }
            self.lastDocumentSnapshot = lastDoc
            self.meals = meals
            self.fetchingMore = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.refreshControl.endRefreshing()
            })
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height - 50 {
            if !fetchingMore {
                paginationData()
            }
        }
    }
    
    fileprivate func paginationData() {
        print("reached bottom of the screen")
        
        // fetch more data and append it to meals variable
        fetchingMore = true
        FirebaseDB.getData(lastDocSnapShot: lastDocumentSnapshot) { meals, lastDoc, error in
            if let error = error  {
                print("Failed paginating data \(error.localizedDescription)")
                return
            }
            
            if let meals = meals, let lastDoc = lastDoc {
                self.meals?.append(contentsOf: meals)
                self.lastDocumentSnapshot = lastDoc
            }
            
            // do not move below code in the if{} above
            self.fetchingMore = false
        }
    }
}

extension PostingWallViewController: CameraViewDelegate {
    func didPost() {
        animationView.isHidden = false
        FirebaseDB.getData(lastDocSnapShot: nil) { meals, lastDoc, error in
            if let error = error {
                print("Failed fetching data \(error.localizedDescription)")
                return
            }
            self.lastDocumentSnapshot = lastDoc
            self.meals = meals
        }
    }
}

// TODO: -Kim
/*
 - Work on adding legit data to firestore (Currently, only front and back images are real in database)
 */
