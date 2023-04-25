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
import FirebaseAuth

class PostingWallViewController: UIViewController {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    var currUser: User?
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
    let notiHours = [8, 12, 18]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupAnimationViews()
        setupRefreshControl()
        setupNavBar()
        setupNotification()
    }
    
    fileprivate func fetchUser() {
        guard let currAuthID = Auth.auth().currentUser?.uid else {
            FirebaseDB.signOut()
            return
        }
        FirebaseDB.getUserProfile(authID: currAuthID) { user, error in
            if let error = error {
                print("Failed fetching user profile \(error.localizedDescription)")
                return
            }
            guard let user = user else {
                print("No matching user profile found for \(currAuthID)")
                return
            }
            self.currUser = user
            self.setupPostCollectionView()
        }
    }
    
    fileprivate func setupNotification() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                let content = UNMutableNotificationContent()
                content.title = "Time to FoodReal."
                content.body = "Let's share your meal with the world!"
                content.badge = NSNumber(value: 1)
                content.sound = .default
                
                for hour in self.notiHours {
                    var dateComp = DateComponents()
                    dateComp.hour = hour
                    dateComp.minute = 0
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                    let request = UNNotificationRequest(identifier: "ID\(hour)", content: content, trigger: trigger)
                    
                    center.add(request) { (error : Error?) in
                        if let theError = error {
                            print(theError.localizedDescription)
                        }
                    }
                }
                
            case .denied, .notDetermined, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    self.view.presentPopUp(with: "Please consider allowing notification to recieve the best experience")
                }
            @unknown default:
                fatalError()
            }
        }
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
        meals = nil
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
        guard let currUser = currUser else {return}
        let settingVC =  SettingViewController(currUser: currUser)
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func didTapCameraButton() {
        #if targetEnvironment(simulator)
            handleCameraForSimulator()
        #else
            let cameraVC = CameraViewController()
            cameraVC.currUser = self.currUser!
            cameraVC.delegate = self
            navigationController?.pushViewController(cameraVC, animated: true)
        #endif
    }
    
    fileprivate func handleCameraForSimulator() {
        self.view.presentPopUp(with: "The feature is not availble on simulators")
    }
}

extension PostingWallViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath as IndexPath) as! PostCollectionViewCell
        if let meals = meals, let currUser = currUser {
            cell.delegate = self
            cell.setupCellView(index: indexPath.row, meals: meals, currUser: currUser)
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
        
        meals?.removeAll()
        meals = nil
        lastDocumentSnapshot = nil
        
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

extension PostingWallViewController: FeedDelegate {
    func didPressLike(isLiked: Bool, index: Int) {
        if isLiked {
            if meals![index].likes == nil {
                meals![index].likes = [String]()
            }
            meals![index].likes?.append((currUser?.uid)!)
        } else {
            meals![index].likes?.removeAll(where: {$0 == currUser?.uid})
        }
    }
}
