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
import RandomColorSwift
import Material

class GroupCreateTVC: UITableViewController {

    private let cellId = "cellId"
    
    
    var groups = [Group]()
    
    var groupRef: FIRDatabaseReference!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: "GroupCreate", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor(hue: 202 / 359, saturation: 3 / 100, brightness: 98 / 100, alpha: 1)
        

        
        navigationController?.navigationBar.barTintColor = UIColor.rgb(redValue: 50, greenValue: 74, blueValue: 100, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 25)]
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Toucan(image: UIImage(named: "Delete-50")!).resizeByScaling(CGSize(width: 30, height: 30)).image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCancel))
        
        configureDatabase()
        setupButton()
        title = "raLLy"
        
        
        

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        groupRef.removeAllObservers()
    }
    
    func configureDatabase() {
        
    groupRef = FIRDatabase.database().reference(withPath: "users").child("-Kc_rBtGYDtxY1hhV6Ie/favoriteGroups")
        groupRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot)
            
            for item in snapshot.children {
                //let group = Group(snapshot: item as! FIRDataSnapshot)
                let group = Group()
                group.name = (item as! FIRDataSnapshot).key
                let snapshotValue = (item as! FIRDataSnapshot).value as! NSArray
                for snap in snapshotValue {
                    group.members.append(snap as! String)
                }
                
                self.groups.append(group)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    func setupButton() {
    let button = FabButton(image: UIImage(named: "Plus Math-50"), tintColor: .white)
        button.backgroundColor = UIColor.rgb(redValue: 50, greenValue: 74, blueValue: 100, alpha: 1)
        button.depthPreset = .depth5
        button.addTarget(self, action: #selector(showContacts), for: .touchUpInside)
        if let navView = navigationController?.view {
            navigationController?.view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: navView.centerXAnchor),
                button.bottomAnchor.constraint(equalTo: navView.bottomAnchor, constant: -53),
                button.widthAnchor.constraint(equalToConstant: 50),
                button.heightAnchor.constraint(equalToConstant: 50)])
        }
    
    
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GroupCreateCell
        let amount = groups[indexPath.row].members.count
        
        cell.groupTitleLabel.text = groups[indexPath.row].name
        
        if 1...amount ~= 1 {
            let firstName = ((groups[indexPath.row].members).first)?.components(separatedBy: " ").first
            let lastName =  ((groups[indexPath.row].members).first)?.components(separatedBy: " ").last
        cell.profileImageView_0.image = FGInitialCircleImage.circleImage(firstName! as NSString, lastName: lastName! as NSString, size: 40, borderWidth: 0, borderColor: .white, backgroundColor: randomColor(hue: .blue, luminosity: .light), textColor: .white)
        cell.profileNameLabel_0.text = "\(firstName!) \(lastName!.substring(to: (lastName!.index((lastName!.startIndex), offsetBy: 1))).capitalized)."
        }
        
        if 1...amount ~= 2 {
        let firstName = ((groups[indexPath.row].members)[1]).components(separatedBy: " ").first
        let lastName =  ((groups[indexPath.row].members)[1]).components(separatedBy: " ").last
        cell.profileImageView_1.image = FGInitialCircleImage.circleImage(firstName! as NSString, lastName: lastName! as NSString, size: 40, borderWidth: 0, borderColor: .white, backgroundColor: randomColor(hue: .blue, luminosity: .light), textColor: .white)
        cell.profileNameLabel_1.text = "\(firstName!) \(lastName!.substring(to: (lastName!.index((lastName!.startIndex), offsetBy: 1))).capitalized)."
        }
    
        if 1...amount ~= 3 {
            let firstName = ((groups[indexPath.row].members)[2]).components(separatedBy: " ").first
            let lastName =  ((groups[indexPath.row].members)[2]).components(separatedBy: " ").last
            cell.profileImageVIew_2.image = FGInitialCircleImage.circleImage(firstName! as NSString, lastName: lastName! as NSString, size: 40, borderWidth: 0, borderColor: .white, backgroundColor: randomColor(hue: .blue, luminosity: .light), textColor: .white)
            cell.profileNameLabel_2.text = "\(firstName!) \(lastName!.substring(to: (lastName!.index((lastName!.startIndex), offsetBy: 1))).capitalized)."
        }
        
        if 1...amount ~= 4 {
            let firstName = ((groups[indexPath.row].members)[3]).components(separatedBy: " ").first
            let lastName =  ((groups[indexPath.row].members)[3]).components(separatedBy: " ").last
            cell.profileImageView_3.image = FGInitialCircleImage.circleImage(firstName! as NSString, lastName: lastName! as NSString, size: 40, borderWidth: 0, borderColor: .white, backgroundColor: randomColor(hue: .blue, luminosity: .light), textColor: .white)
            cell.profileNameLabel_3.text = "\(firstName!) \(lastName!.substring(to: (lastName!.index((lastName!.startIndex), offsetBy: 1))).capitalized)."
        }
        
        if 1...amount ~= 5 {
            let firstName = ((groups[indexPath.row].members)[4]).components(separatedBy: " ").first
            let lastName =  ((groups[indexPath.row].members)[4]).components(separatedBy: " ").last
            cell.profileImageView_4.image = FGInitialCircleImage.circleImage(firstName! as NSString, lastName: lastName! as NSString, size: 40, borderWidth: 0, borderColor: .white, backgroundColor: randomColor(hue: .blue, luminosity: .light), textColor: .white)
            cell.profileNameLabel_4.text = "\(firstName!) \(lastName!.substring(to: (lastName!.index((lastName!.startIndex), offsetBy: 1))).capitalized)."
        }
        
        
        cell.backgroundColor = UIColor(hue: 202 / 359, saturation: 3 / 100, brightness: 98 / 100, alpha: 1)
        cell.disclosureIndicator.isHidden =  true
        cell.selectionStyle = .none

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .purple
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Favorite Groups", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 16)])
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        NSLayoutConstraint.activate([label.widthAnchor.constraint(equalTo: headerView.widthAnchor),
                                     label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)])
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func showContacts() {
    let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromBottom
        
        let containerView = self.view.window
        containerView?.layer.add(transition, forKey: nil)
        let nextVC = FavoritedGroupCreateController()
        nextVC.delegate = self
        present(UINavigationController(rootViewController: nextVC), animated: false, completion: nil)
    
    
    }
    
    func handleCancel() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        
        let containerView = self.view.window
        containerView?.layer.add(transition, forKey: nil)
    
        
    self.dismiss(animated: false, completion: nil)
    
    }

}

extension GroupCreateTVC: GroupMemberDelegate {

    
    func chosenMembers(members: [String], groupName: String) {
        let newGroup = Group()
        newGroup.name = groupName
        newGroup.members = members
        self.groups.append(newGroup)
        let values = ["\(groupName)": members]
        
        
        groupRef.updateChildValues(values)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   128 / 255,
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}


