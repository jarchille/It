//
//  TimePickerViewController.swift
//  AppStore
//
//  Created by Jonathan Archille on 2/8/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pickerNib = Bundle.main.loadNibNamed("PickerView", owner: self, options: nil)?.first as! TimePickerPage
        pickerNib.timePicker.datePickerMode = .time
        pickerNib.timePicker.setValue(UIColor.white, forKey: "textColor")
        pickerNib.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerNib)
        
        NSLayoutConstraint.activate([
                           pickerNib.widthAnchor.constraint(equalTo: view.widthAnchor),
                           pickerNib.heightAnchor.constraint(equalTo: view.heightAnchor)
                                    ])
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

class TimePickerPage: UIView {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
}
