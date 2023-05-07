//
//  PostCollectionViewCell.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/4/23.
//

import UIKit
import SDWebImage

protocol FeedDelegate {
    func didPressLike(isLiked: Bool, index: Int)
}

protocol DescriptionDelegate {
    func didPressDescription(postContent: UIView)
}

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var numOfLikesLabel: UILabel!
    @IBOutlet weak var postContentView: UIView!
    
    var isOn: Bool = false
    var meals = [Meal]()
    var index = 0
    var currUser = User()
    var delegate: FeedDelegate!
    var descriptionDelegate: DescriptionDelegate!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    fileprivate func setupView() {
        userImageView.createRoundCorner(cornerRadius: userImageView.frame.height / 2)
        frontImageView.createRoundCorner(cornerRadius: 18)
        backImageView.createRoundCorner(cornerRadius: 18)

        numOfLikesLabel.text = "0"
        frontImageView.createBorder(color: UIColor.black, width: 2)
        moreButton.setTitle("", for: .normal)
        likeButton.setTitle("", for: .normal)
    }
    
    fileprivate func setButtonBackGround(view: UIButton, on: UIImage, off: UIImage, onOffStatus: Bool ) {
        switch onOffStatus {
            case true:
            // change backgroundImage to hart image
                view.setImage(on, for: .normal)
            default:
                view.setImage(off, for: .normal)
        }
    }
    
    func setupCellView(index: Int, meals: [Meal], currUser: User) {
        likeButton.tag = index
        self.currUser = currUser
        self.meals = meals
        self.index = index
        
        if let url = URL(string: meals[index].frontImageURL ?? "") {
            self.frontImageView.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground)
        } else {
            self.frontImageView.image = UIImage(named: "food1")
        }
        
        if let url = URL(string: meals[index].backImageURL ?? "") {
            self.backImageView.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground)
        } else {
            self.backImageView.image = UIImage(named: "food1")
        }
        
        if let url = URL(string: meals[index].authorProfilePicture ?? "") {
            self.userImageView.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground)
        } else {
            self.userImageView.image = UIImage(named: "cat")
        }
        
        guard let time = meals[index].dateTime else {return}
        let format = time.getFormattedDate(format: "MMM d, h:mm a")
        
        timeLabel.text = format
        nameLabel.text = meals[index].authorUsername
        
        if let likeUsers = meals[index].likes {
            if likeUsers.contains(currUser.uid!) {
                isOn = true
            } else {
                isOn = false
            }
            numOfLikesLabel.text = "\(likeUsers.count)"
        } else {
            isOn = false
            numOfLikesLabel.text = "0"
        }
        setButtonBackGround(view: likeButton, on: UIImage(named: "heartRed") ?? UIImage(), off: UIImage(named: "heartWhiteBordered") ?? UIImage(), onOffStatus: isOn)
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        isOn.toggle()
        setButtonBackGround(view: sender, on: UIImage(named: "heartRed") ?? UIImage(), off: UIImage(named: "heartWhiteBordered") ?? UIImage(), onOffStatus: isOn)
        if (isOn) {
            FirebaseDB.addLike(to: meals[index], likedUser: currUser) { [weak self] error in
                self?.finishUpdatingLikesInDB(error)
            }
        } else {
            FirebaseDB.removeLike(to: meals[index], likedUser: currUser) { [weak self] error in
                self?.finishUpdatingLikesInDB(error)
            }
        }
    }
    
    @IBAction func didTapDescriptionButton(_ sender: Any) {
        descriptionDelegate.didPressDescription(postContent: postContentView)
    }
    
    private func finishUpdatingLikesInDB(_ error: Error?) {
        if let _ = error {
            print("Failed appending to likeUser to the db")
            return
        }
        print("isOn: \(isOn)")
        delegate.didPressLike(isLiked: isOn, index: likeButton.tag)
    }
}
