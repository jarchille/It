//
//  TimePickerViewController.swift
//  AppStore
//
//  Created by Jonathan Archille on 1/26/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

class FavoriteLocationsVC: UITableViewController {

    private let cellId = "cellId"
    
    let data = ["Alpha": "Bravo", "Charlie": "Delta", "Echo": "Foxtrot"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        title = "Favorites"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as UITableViewCell
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = "4 Rivers Smokehouse"
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.text = "4862 Carver Drive, Orlando FL 321812"
        
        return cell
    }
   
    


}
