//
//  GroupSelectViewController.swift
//  AppStore
//
//  Created by Jonathan Archille on 2/8/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toucan
import Material
import SwiftyPickerPopover
import Firebase
import RandomColorSwift

class GroupSelectViewController: UITableViewController {
    
    var allContacts = [User]()
    var selectedContacts = [User]()
    
    var groupRef: FIRDatabaseReference!
    
    var groups = [Group]()
    
    var popoverAnchorView: UIView!
    
    private let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GroupCreate", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor(hue: 202 / 359, saturation: 3 / 100, brightness: 98 / 100, alpha: 1)
        
        
        navigationController?.navigationBar.barTintColor = UIColor.rgb(redValue: 50, greenValue: 73, blueValue: 100, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 25)]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Toucan(image: UIImage(named: "Delete-50")!).resizeByScaling(CGSize(width: 30, height: 30)).image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCancel))
        
        fetchUsers()
        prepareButton()
        configureDatabase()
        
        title = "raLLy"
        
        popoverAnchorView = UIView(frame: CGRect(x: view.frame.width / 2, y: 40, width: 0, height: 0))
        view.addSubview(popoverAnchorView)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    func configureDatabase() {
        
        groupRef = FIRDatabase.database().reference(withPath: "users").child("-Kc_rBtGYDtxY1hhV6Ie/favoriteGroups")
        groupRef.observe(.value, with: { snapshot in
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
            cell.profileImageView_0.image = FGInitialCircleImage.circleImage(firstName! as NSString, lastName: lastName! as NSString, size: 40, borderWidth: 0, borderColor: .white, backgroundColor: randomColor(), textColor: .white)
            cell.profileNameLabel_0.text = "\(firstName!) \(lastName!.substring(to: (lastName!.index((lastName!.startIndex), offsetBy: 1))).capitalized)."
        }
        
        if 1...amount ~= 2 {
            let firstName = ((groups[indexPath.row].members)[1]).components(separatedBy: " ").first
            let lastName =  ((groups[indexPath.row].members)[1]).components(separatedBy: " ").last
            cell.profileImageView_1.image = FGInitialCircleImage.circleImage(firstName! as NSString, lastName: lastName! as NSString, size: 40, borderWidth: 0, borderColor: .white, backgroundColor: randomColor(), textColor: .white)
            cell.profileNameLabel_1.text = "\(firstName!) \(lastName!.substring(to: (lastName!.index((lastName!.startIndex), offsetBy: 1))).capitalized)."
        }
        
        if 1...amount ~= 3 {
            let firstName = ((groups[indexPath.row].members)[2]).components(separatedBy: " ").first
            let lastName =  ((groups[indexPath.row].members)[2]).components(separatedBy: " ").last
            cell.profileImageVIew_2.image = FGInitialCircleImage.circleImage(firstName! as NSString, lastName: lastName! as NSString, size: 40, borderWidth: 0, borderColor: .white, backgroundColor: randomColor(), textColor: .white)
            cell.profileNameLabel_2.text = "\(firstName!) \(lastName!.substring(to: (lastName!.index((lastName!.startIndex), offsetBy: 1))).capitalized)."
        }
        
        if 1...amount ~= 4 {
            let firstName = ((groups[indexPath.row].members)[3]).components(separatedBy: " ").first
            let lastName =  ((groups[indexPath.row].members)[3]).components(separatedBy: " ").last
            cell.profileImageView_3.image = FGInitialCircleImage.circleImage(firstName! as NSString, lastName: lastName! as NSString, size: 40, borderWidth: 0, borderColor: .white, backgroundColor: randomColor(), textColor: .white)
            cell.profileNameLabel_3.text = "\(firstName!) \(lastName!.substring(to: (lastName!.index((lastName!.startIndex), offsetBy: 1))).capitalized)."
        }
        
        if 1...amount ~= 5 {
            let firstName = ((groups[indexPath.row].members)[4]).components(separatedBy: " ").first
            let lastName =  ((groups[indexPath.row].members)[4]).components(separatedBy: " ").last
            cell.profileImageView_4.image = FGInitialCircleImage.circleImage(firstName! as NSString, lastName: lastName! as NSString, size: 40, borderWidth: 0, borderColor: .white, backgroundColor: randomColor(), textColor: .white)
            cell.profileNameLabel_4.text = "\(firstName!) \(lastName!.substring(to: (lastName!.index((lastName!.startIndex), offsetBy: 1))).capitalized)."
            
        }
        
        cell.backgroundColor = UIColor(hue: 202 / 359, saturation: 3 / 100, brightness: 98 / 100, alpha: 1)
        cell.disclosureIndicator.isHidden = false
        cell.selectionStyle = .none
        
        return cell
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
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.4, animations: {
            
            self.view.alpha = 0.5
            self.navigationController?.navigationBar.alpha = 0.5
            
        })
        
        DatePickerPopover.appearFrom(originView: popoverAnchorView, baseViewController: self, title: "What's a good time?", dateMode: .time, initialDate: Date(), doneAction: { time in
            
            DispatchQueue.main.async {
                self.present(StatusPageViewController(), animated: true, completion: nil)
            }
            
        }, cancelAction: {
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.view.alpha = 1
                self.navigationController?.navigationBar.alpha = 1
                
            })
            
            
        })
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    
    
    
    func handleCancel() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        
        let containerView = self.view.window
        containerView?.layer.add(transition, forKey: nil)
        
        
        self.dismiss(animated: false, completion: nil)
        
        
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
    
    var button: RaisedButton!
    
    func prepareButton() {
        button = RaisedButton(title: "Make A One-Time Group", titleColor: .white)
        button.backgroundColor = UIColor.rgb(redValue: 50, greenValue: 73, blueValue: 100, alpha: 1)
        button.depthPreset = .depth5
        
        button.addTarget(self, action: #selector(prepareButtonPressd), for: .touchUpInside)
        if let navView = navigationController?.view {
            navigationController?.view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: navView.centerXAnchor),
                button.bottomAnchor.constraint(equalTo: navView.bottomAnchor, constant: -53),
                button.widthAnchor.constraint(equalToConstant: 210),
                button.heightAnchor.constraint(equalToConstant: 50)])
        }
        
        
        /*button.backgroundColor = UIColor.randomColor()
         button.translatesAutoresizingMaskIntoConstraints = false
         button.addTarget(self, action: #selector(prepareButtonPressd), for: .touchUpInside)
         view.addSubview(button)
         
         let buttonLayerView = UIView()
         buttonLayerView.backgroundColor = .red
         buttonLayerView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(buttonLayerView)
         
         buttonLayerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
         buttonLayerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
         buttonLayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true*/
        
        
    }
    
    
    
    
    
    func prepareButtonPressd() {
        show(UINavigationController(rootViewController: OneTimeGroupCreateController()), sender: self)
        
    }
}


extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
    
    
}
