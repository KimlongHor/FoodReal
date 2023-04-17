//
//  PostCollectionViewCell.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/4/23.
//

import UIKit

protocol FeedDelegate {
    func didPressLike(isLiked: Bool, index: Int)
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
    
    var isOn: Bool = false
    var meal = Meal()
    var currUser = User()
    var delegate: FeedDelegate!
    
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
    
    func setupCellView(index: Int, meal: Meal, currUser: User) {
        likeButton.tag = index
        self.currUser = currUser
        self.meal = meal
        frontImageView.image = UIImage(data: meal.frontImage ?? Data())
        backImageView.image = UIImage(data: meal.backImage ?? Data())
        timeLabel.text = meal.dateTime?.description
        nameLabel.text = meal.authorUsername
        
        guard let likeUsers = meal.likes else {return}
        for likeUser in likeUsers {
            if currUser.uid! == likeUser {
                isOn = true
                break
            } else {
                isOn = false
            }
        }
        
        numOfLikesLabel.text = "\(likeUsers.count)"
        setButtonBackGround(view: likeButton, on: UIImage(named: "heartRed") ?? UIImage(), off: UIImage(named: "heartWhiteBordered") ?? UIImage(), onOffStatus: isOn)
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        isOn.toggle()
        setButtonBackGround(view: sender, on: UIImage(named: "heartRed") ?? UIImage(), off: UIImage(named: "heartWhiteBordered") ?? UIImage(), onOffStatus: isOn)
        if (isOn) {
            FirebaseDB.addLike(to: meal, likedUser: currUser) { [weak self] error in
                self?.finishUpdatingLikesInDB(error)
            }
        } else {
            FirebaseDB.removeLike(to: meal, likedUser: currUser) { [weak self] error in
                self?.finishUpdatingLikesInDB(error)
            }
        }
    }
    
    private func finishUpdatingLikesInDB(_ error: Error?) {
        if let _ = error {
            print("Failed appending to likeUser to the db")
            return
        }
        
        delegate.didPressLike(isLiked: isOn, index: likeButton.tag)

    }
}
