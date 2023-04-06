//
//  ProfileTableViewCell.swift
//  FoodReal
//
//  Created by Kimlong Hor on 4/5/23.
//

import UIKit

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
        
        nameLabel.textColor = .white
        profileIdLabel.textColor = .white
        profileIdLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    func setupView(with model: Profile) {
        nameLabel.text = model.username
        profileIdLabel.text = model.userId
    }
}
