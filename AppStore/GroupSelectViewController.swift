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

class GroupSelectViewController: UITableViewController {

    var allContacts = [User]()
    var selectedContacts = [User]()
    
    var popoverAnchorView: UIView!
    
    private let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GroupCreate", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor(hue: 202 / 359, saturation: 3 / 100, brightness: 98 / 100, alpha: 1)
        
        
        navigationController?.navigationBar.barTintColor = UIColor.rgb(redValue: 50, greenValue: 73, blueValue: 100, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        fetchUsers()
        prepareButton()
        
        title = "Invite friends!"
        
        popoverAnchorView = UIView(frame: CGRect(x: view.frame.width / 2, y: 40, width: 0, height: 0))
        view.addSubview(popoverAnchorView)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
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
        /*cell.textLabel?.text = "         \(user.name!)"
         cell.textLabel?.textColor = UIColor.rgb(redValue: 51, greenValue: 30, blueValue: 54, alpha: 1)
         cell.profileImageView.image = Toucan(image: #imageLiteral(resourceName: "user")).resize(CGSize(width: 40, height: 40), fitMode: Toucan.Resize.FitMode.crop).maskWithEllipse().image*/
        
        return cell
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
        return 110
    }
    
    
    
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
        
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
        button = RaisedButton(title: "Create a One Time Group", titleColor: .white)
        button.backgroundColor = .blue
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
