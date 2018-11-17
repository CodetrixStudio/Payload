//
//  TabBarController.swift
//  PayloadDemo
//
//  Created by Parveen Khatkar on 17/11/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            LocalTableViewController()
        ]
        
        tabBar.items?[0].image = UIImage(named: "icons8-folder-25");
        tabBar.items?[0].title = "Local";
    }
    
}
