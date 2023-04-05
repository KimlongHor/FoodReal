//
//  SettingTableViewCell.swift
//  FoodReal
//
//  Created by Kimlong Hor on 3/30/23.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(with model: SettingsOption) {
        iconImageView.image = model.icon
        nameLabel.text = model.title
    }
}
