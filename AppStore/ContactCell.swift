//
//  ContactCell.swift
//  AppStore
//
//  Created by Jonathan Archille on 2/7/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        circleImage.backgroundColor = UIColor.randomColor()
        circleImage.layer.masksToBounds = true
        circleImage.layer.cornerRadius = 15

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
