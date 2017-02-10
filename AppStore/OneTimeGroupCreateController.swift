//
//  AllContactsViewController.swift
//  AppStore
//
//  Created by Jonathan Archille on 1/25/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toucan
import SwiftyPickerPopover
import Material


class OneTimeGroupCreateController: UITableViewController {
    
    var allContacts = [User]()
    var selectedContacts: [Any] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Toucan(image: UIImage(named: "Undo-64")!).resizeByScaling(CGSize(width: 30, height: 30)).image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCancel))
        
        fetchUsers()
        prepareButton()
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        title = "Contacts"
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
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
    
    func prepareButton() {
    
        button = RaisedButton(title: "Confirm", titleColor: .white)
        button.backgroundColor = UIColor.rgb(redValue: 63, greenValue: 219, blueValue: 76, alpha: 1)
        button.depthPreset = .depth5
        button.cornerRadius = 10
        
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        if let navView = navigationController?.view {
            navigationController?.view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: navView.centerXAnchor),
                button.bottomAnchor.constraint(equalTo: navView.bottomAnchor, constant: -40),
                button.widthAnchor.constraint(equalToConstant: 125),
                button.heightAnchor.constraint(equalToConstant: 44)])
        }

    }
    
    func doneButtonPressed() {
        
        UIView.animate(withDuration: 0.4, animations: {
        
            self.view.alpha = 0.5
            self.navigationController?.navigationBar.alpha = 0.5
        
        })
        
        DatePickerPopover.appearFrom(originView: button, baseViewController: self, title: "What's a good time?", dateMode: .time, initialDate: Date(), doneAction: { time in
            
            DispatchQueue.main.async {
                let nextVC = StatusPageViewController()
                if let destination = MainMapViewController.rallyPoint {
                nextVC.ironYardCoords = destination
                }
                var selectedNames = [String]()
                for index in self.tableView.indexPathsForSelectedRows! {
                    
                    selectedNames.append(self.allContacts[index.row].name!)
                }
                nextVC.invitees = selectedNames
                self.present(nextVC, animated: true, completion: nil)
            }
            
            
        }, cancelAction: {
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.view.alpha = 1
                self.navigationController?.navigationBar.alpha = 1
                
            })
        
        
        })
        
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

