//
//  Group.swift
//  AppStore
//
//  Created by Jonathan Archille on 2/5/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import Foundation
import Firebase

class Group {
    var name: String = ""
    var members: [String] = []
    
    /*init(snapshot: Any) {
        name = (snapshot as! FIRDataSnapshot).key
        let snapshotValue = (snapshot as! FIRDataSnapshot).value as! NSArray
        for snap in snapshotValue{
            members.append(snap as! String)
        }
        
    }*/
}
