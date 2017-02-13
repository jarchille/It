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
import SCLAlertView

protocol GroupMemberDelegate {
    func chosenMembers(members: [String], groupName: String)
}

class FavoritedGroupCreateController: UITableViewController {
    
    var allContacts = [User]()
    //var selectedContacts = [User]()
    var button: RaisedButton!
    
    var delegate: GroupMemberDelegate?
    
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
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none

    }
    
    
    
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func saveGroup() {
        
        let appearance = SCLAlertView.SCLAppearance(kDefaultShadowOpacity: 0.7, kCircleTopPosition: 0.0, kCircleBackgroundTopPosition: 6.0, kCircleHeight: 56.0, kCircleIconHeight: 20.0, kTitleTop: 30.0, kTitleHeight: 25.0, kWindowWidth: 240.0, kWindowHeight: 178.0, kTextHeight: 90.0, kTextFieldHeight: 45.0, kTextViewdHeight: 80.0, kButtonHeight: 45.0, kTitleFont: UIFont.systemFont(ofSize: 20), kTextFont: UIFont.systemFont(ofSize: 14), kButtonFont: UIFont.boldSystemFont(ofSize: 14), showCloseButton: false, showCircularIcon: false, shouldAutoDismiss: true, contentViewCornerRadius: 5.0, fieldCornerRadius: 3.0, buttonCornerRadius: 3.0, hideWhenBackgroundViewIsTapped: true, contentViewColor: UIColor.rgb(redValue: 50, greenValue: 73, blueValue: 100, alpha: 1), contentViewBorderColor: .white, titleColor: .white)
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("")
        alert.addButton("Set Group Name") {
            var selectedNames = [String]()
            for index in self.tableView.indexPathsForSelectedRows! {
                
                selectedNames.append(self.allContacts[index.row].name!)
            
                self.handleCancel()
            }
            
            self.delegate?.chosenMembers(members: selectedNames, groupName: txt.text!)
        
        }
        alert.showEdit("Cool, a new group", subTitle:"This group is called...")
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
