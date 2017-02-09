//
//  TabBarController.swift
//  AppStore
//
//  Created by Jonathan Archille on 1/30/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import Toucan

class TabBarController: UITabBarController {

        let list_icon = Toucan(image: #imageLiteral(resourceName: "list")).resize(CGSize(width: 25, height: 25), fitMode: Toucan.Resize.FitMode.scale).image
        let pin_icon = Toucan(image: #imageLiteral(resourceName: "mapPin")).resize(CGSize(width: 25, height: 25), fitMode: Toucan.Resize.FitMode.scale).image
        var settings_icon = Toucan(image: #imageLiteral(resourceName: "like_2")).resize(CGSize(width: 25, height: 25), fitMode: Toucan.Resize.FitMode.scale).image

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let offset = UIOffsetMake(0, -3)
        
        let groupCreateController =  UINavigationController(rootViewController: GroupCreateTVC())
        groupCreateController.tabBarItem.image = list_icon.withRenderingMode(.alwaysOriginal)
        groupCreateController.tabBarItem.titlePositionAdjustment = offset
        groupCreateController.tabBarItem.title = "Groups"
        
        let favLocationsController = UINavigationController(rootViewController: FavoriteLocationsVC())
        favLocationsController.tabBarItem.titlePositionAdjustment = offset
        favLocationsController.tabBarItem.image = settings_icon.withRenderingMode(.alwaysOriginal)
        favLocationsController.tabBarItem.title = "Favorites"
        
        let mapController = MainMapViewController()
        mapController.tabBarItem.image = pin_icon.withRenderingMode(.alwaysOriginal)
        mapController.tabBarItem.titlePositionAdjustment = offset
        mapController.tabBarItem.title = "Map"
       
        
        viewControllers = [groupCreateController, mapController, favLocationsController]
        self.selectedIndex = 1
        

    }


}
