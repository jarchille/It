//
//  Group.swift
//  AppStore
//
//  Created by Jonathan Archille on 2/5/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import Foundation
import Firebase

struct Group {
    let name: String
    var members: [String] = []
    
    init(snapshot: FIRDataSnapshot) {
        name = snapshot.key
        let snapshotValue = snapshot.value as! NSArray
        for snap in snapshotValue{
            members.append(snap as! String)
        }
    }
}
