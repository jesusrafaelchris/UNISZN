//
//  TabBarController.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homePage = HomePage()
        let homeImage = UIImage(systemName: "house")
        homePage.tabBarItem = UITabBarItem(title: "Home", image: homeImage, tag: 0)
        
        let searchpage = Search()
        searchpage.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let messagesPage = MessagesMainView()
        let messagesImage = UIImage(systemName: "message")
        messagesPage.tabBarItem = UITabBarItem(title: "Messages", image: messagesImage, tag: 2)
        
        
        let profilePage = Profile()
        let profileImage = UIImage(systemName: "person")
        profilePage.tabBarItem = UITabBarItem(title: "Profile", image: profileImage, tag: 3)
        
        let tabbarList = [homePage, searchpage, messagesPage, profilePage]
        
        viewControllers = tabbarList.map {
            UINavigationController(rootViewController: $0)
        }
        
    }
    
}
