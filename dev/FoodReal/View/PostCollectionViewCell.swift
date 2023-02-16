//
//  PostCollectionViewCell.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/4/23.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {

    var isOn: Bool = false
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    fileprivate func setupView() {
        userImageView.createRoundCorner(cornerRadius: userImageView.frame.height / 2)
        frontImageView.createRoundCorner(cornerRadius: 18)
        backImageView.createRoundCorner(cornerRadius: 18)
        
        frontImageView.createBorder(color: UIColor.black, width: 2)
        moreButton.setTitle("", for: .normal)
        likeButton.setTitle("", for: .normal)
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        isOn.toggle()
        setButtonBackGround(view: sender, on: UIImage(named: "heartRed") ?? UIImage(), off: UIImage(named: "heartWhiteBordered") ?? UIImage(), onOffStatus: isOn)
    }
    
    func setButtonBackGround(view: UIButton, on: UIImage, off: UIImage, onOffStatus: Bool ) {
        switch onOffStatus {
            case true:
            // change backgroundImage to hart image
                view.setImage(on, for: .normal)
            default:
                view.setImage(off, for: .normal)
        }
    }
}
