//
//  TabBarController.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let postingPage = PostingPage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let homePage = HomePage(collectionViewLayout: UICollectionViewFlowLayout())
        let homeImage = UIImage(systemName: "house")
        homePage.tabBarItem = UITabBarItem(title: "Home", image: homeImage, tag: 0)
        
        let searchpage = Search()
        searchpage.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let postingPageImage = UIImage(systemName: "plus.square.on.square")
        postingPage.tabBarItem = UITabBarItem(title: "Post", image: postingPageImage, tag: 2)
        
        let messagesPage = MessagesMainView()
        let messagesImage = UIImage(systemName: "message")
        messagesPage.tabBarItem = UITabBarItem(title: "Messages", image: messagesImage, tag: 3)
        
        let profilePage = Profile()
        let profileImage = UIImage(systemName: "person")
        profilePage.tabBarItem = UITabBarItem(title: "Profile", image: profileImage, tag: 4)
        
        let tabbarList = [homePage, searchpage, postingPage, messagesPage, profilePage]
        
        viewControllers = tabbarList.map {
            UINavigationController(rootViewController: $0)
        }
    }

    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
             if selectedIndex == 2 {
                let nav = UINavigationController(rootViewController: postingPage)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
                return false
             }

        return true
        }
   
    }
  

