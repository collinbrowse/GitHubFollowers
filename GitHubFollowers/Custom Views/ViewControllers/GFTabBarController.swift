//
//  GFTabBarController.swift
//  GitHubFollowers
//
//  Created by Collin Browse on 4/20/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBarController()
    }
    
    
    func configureTabBarController() {
        
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNavigationController(), createFavoritesNavigationController()]
    }
    
    
    func createSearchNavigationController() -> UINavigationController {
        
        let searchVC = SearchViewController()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }

    
    func createFavoritesNavigationController() -> UINavigationController {
        
        let favoritesListVC = FavoritesListViewController()
        favoritesListVC.title = "Favorites"
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesListVC)
    }
    

    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemGreen
    }

}
