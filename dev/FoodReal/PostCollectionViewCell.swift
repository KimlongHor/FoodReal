//
//  PostCollectionViewCell.swift
//  FoodReal
//
//  Created by Kimlong Hor on 2/4/23.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var moreButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    fileprivate func setupView() {
        userImageView.createRoundCorner(cornerRadius: userImageView.frame.height / 2)
        frontImageView.createRoundCorner(cornerRadius: 18)
        backImageView.createRoundCorner(cornerRadius: 18)
    }

}
