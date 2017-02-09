//
//  GroupCreateTVC.swift
//  AppStore
//
//  Created by Jonathan Archille on 1/31/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import Toucan
import Firebase

class GroupCreateTVC: UITableViewController {

    private let cellId = "cellId"
    
    
    var groups = [Group]()
    
    
    var groupRef: FIRDatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: "GroupCreate", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor(hue: 202 / 359, saturation: 3 / 100, brightness: 98 / 100, alpha: 1)

        
        navigationController?.navigationBar.barTintColor = UIColor.rgb(redValue: 50, greenValue: 73, blueValue: 100, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add a group", style: .plain, target: self, action: #selector(showContacts))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        configureDatabase()
        
        title = "Favorites"

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDatabase() {
        
    /*let uid = FIRAuth.auth()?.currentUser?.uid
    groupRef = FIRDatabase.database().reference(withPath: "users").child(uid!).child("favGroups")
        groupRef.observe(.value, with: { snapshot in
            
            for item in snapshot.children {
                let group = Group(snapshot: item as! FIRDataSnapshot)
                self.groups.append(group)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        })*/
    
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GroupCreateCell
        //let user = allContacts[indexPath.row]
        let titles = ["Gym Partners", "Family", "Classmates", "The Lunch Gang"]
        let randomIndex = Int(arc4random_uniform(UInt32(titles.count)))
        
        cell.groupTitleLabel.text = titles[randomIndex]
        cell.profileImageView_0.image = FGInitialCircleImage.circleImage("Jonathan", lastName: "Archille", size: 40, borderWidth: 0, borderColor: .white, backgroundColor: UIColor.randomColor(), textColor: .white)
        cell.profileNameLabel_0.text = "Jonathan A."
        cell.profileImageView_1.image = FGInitialCircleImage.circleImage("Jonathan", lastName: "Archille", size: 40, borderWidth: 0, borderColor: .white, backgroundColor: UIColor.randomColor(), textColor: .white)
        
        cell.backgroundColor = UIColor(hue: 202 / 359, saturation: 3 / 100, brightness: 98 / 100, alpha: 1)
        
        cell.disclosureIndicator.isHidden =  true

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func showContacts() {
    let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromRight
        
        let containerView = self.view.window
        containerView?.layer.add(transition, forKey: nil)
        present(UINavigationController(rootViewController: FavoritedGroupCreateController()), animated: false, completion: nil)
    
    
    }
    
    func handleCancel() {
    self.dismiss(animated: true, completion: nil)
    
    }

}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}


