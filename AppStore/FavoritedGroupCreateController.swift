//
//  FavoritedGroupCreateController.swift
//  AppStore
//
//  Created by Jonathan Archille on 2/9/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toucan
import SwiftyPickerPopover
import Material
import Firebase


class FavoritedGroupCreateController: UITableViewController {
    
    var allContacts = [User]()
    var selectedContacts = [User]()
    var button: RaisedButton!
    
    let globalTint = UIColor(hue: 202 / 359, saturation: 3 / 100, brightness: 98 / 100, alpha: 1)
    
    private let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelection = true
        tableView.backgroundColor = globalTint
        
        
        navigationController?.navigationBar.barTintColor = UIColor.rgb(redValue: 50, greenValue: 73, blueValue: 100, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveGroup))
        
        fetchUsers()
        configureDatabase()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        title = "Select group members"
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func configureDatabase() {
    
    
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allContacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.accessoryType = rowIsSelected ? .checkmark : .none
        
        let user = allContacts[indexPath.row]
        
        cell.circleImage.image = #imageLiteral(resourceName: "user")
        
        
        cell.backgroundColor = globalTint
        cell.nameLabel?.text = user.name!
        cell.textLabel?.textColor = UIColor.rgb(redValue: 51, greenValue: 30, blueValue: 54, alpha: 1)
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        print(tableView.indexPathsForSelectedRows)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
        print(tableView.indexPathsForSelectedRows)
    }
    
    
    
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func saveGroup() {
        let alert = UIAlertController(title: "Cool, a new group", message: "Name your new group", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ in
            
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            
            
            
            self.handleCancel()
        
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func fetchUsers() {
        
        guard let path = Bundle.main.path(forResource: "users", ofType: "json") else { return }
        guard let jsonData = NSData(contentsOfFile: path) else { return }
        let jsonObject = JSON(data: jsonData as Data)
        
        var arrayToShuffle = [User]()
        
        for (_, object) in jsonObject
        {
            let user = User()
            
            user.name = object["name"].stringValue
            user.photo = UIImage(named: object["image"].stringValue)
            arrayToShuffle.append(user)
        }
        
        allContacts = arrayToShuffle.shuffled()
    }
    

}
