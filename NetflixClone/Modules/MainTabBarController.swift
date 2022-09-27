//
//  MainTabBarController.swift
//  NetflixClone
//
//  Created by Алексей Павленко on 27.09.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        vc1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.circle"), selectedImage: UIImage(systemName: "house.circle.fill"))
        vc1.title = "Home"
        
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        vc2.tabBarItem = UITabBarItem(title: "Coming Soon", image: UIImage(systemName: "play.circle"), selectedImage: UIImage(systemName: "play.circle.fill"))
        vc1.title = "Coming"
        
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        vc3.tabBarItem = UITabBarItem(title: "Top Searches", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        vc3.title = "Top Searches"
        
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        vc4.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.circle"), selectedImage: UIImage(systemName: "arrow.down.circle.fill"))
        vc4.title = "Downloads"
        
        tabBar.tintColor = .label
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }


}

