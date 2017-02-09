//
//  _GroupCreateCell.swift
//  AppStore
//
//  Created by Jonathan Archille on 2/2/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

protocol groupCreatCellDelegate {
    func showPicker()
}

class _GroupCreateCell: UITableViewCell {
    
    var delegate: groupCreatCellDelegate?
    
    @IBOutlet weak var groupTitleLabel: UILabel!

    @IBOutlet weak var memberLabel_0: UILabel!
    @IBOutlet weak var memberLabel_1: UILabel!
    @IBOutlet weak var memberLabel_2: UILabel!
    @IBOutlet weak var memberLabel_3: UILabel!
    @IBOutlet weak var memberLabel_4: UILabel!
    @IBOutlet weak var memberLabel_5: UILabel!
    
}
