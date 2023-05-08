//
//  ProfileTableViewCell.swift
//  FoodReal
//
//  Created by Kimlong Hor on 4/5/23.
//

import UIKit
import SDWebImage

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    fileprivate func setupUI() {
        profileImageView.backgroundColor = .orange
        profileImageView.createRoundCorner(cornerRadius: profileImageView.frame.height / 2)
        profileImageView.contentMode = .scaleAspectFill
        
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        profileIdLabel.textColor = .white
        profileIdLabel.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    func setupView(with model: Profile) {
        nameLabel.text = model.username
        profileIdLabel.text = model.userId
        
        if let url = URL(string: model.profileImageURL ?? "") {
            profileImageView.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground)
        } else {
            profileImageView.image = UIImage(named: "user")
        }
    }
}
