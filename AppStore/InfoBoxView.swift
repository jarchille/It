//
//  InfoBoxView.swift
//  AppStore
//
//  Created by Jonathan Archille on 1/30/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

protocol infoBoxViewDelegate {
    func dismissView()
    func showGroupSelectTVC()
}


class InfoBoxView: UIView {
    
    var delegate: infoBoxViewDelegate?

    
    @IBOutlet var locationImageView: UIImageView!
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var categoriesLabel: UILabel!
    @IBAction func dismiss(sender: UIButton) {
        delegate?.dismissView()
        print("Tap inside xib")
    }

    @IBAction func setRallyPoint(_ sender: UIButton) {
        delegate?.showGroupSelectTVC()
    }
    

    

    
    
    
    
  

}
