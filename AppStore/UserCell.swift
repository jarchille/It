//
//  UserCell.swift
//  AppStore
//
//  Created by Jonathan Archille on 1/25/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import Toucan


class UserCell: UITableViewCell {

    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
    }()
    
    //checkbox.translatesAutoresizingMaskIntoConstraints = false


    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    
    
    }
    

    
    
    
    
    
    

}
