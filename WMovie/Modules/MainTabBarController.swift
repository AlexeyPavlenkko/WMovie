//
//  MainTabBarController.swift
//  NetflixClone
//
//  Created by Алексей Павленко on 27.09.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    let moduleBuilder: ModuleBuilderProtocol
    
    init(moduleBuilder: ModuleBuilderProtocol) {
        self.moduleBuilder = moduleBuilder
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let vc1 = moduleBuilder.build(module: .home)
        vc1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.circle"), selectedImage: UIImage(systemName: "house.circle.fill"))
        
        let vc2 = moduleBuilder.build(module: .upcoming)
        vc2.tabBarItem = UITabBarItem(title: "Coming Soon", image: UIImage(systemName: "play.circle"), selectedImage: UIImage(systemName: "play.circle.fill"))
        
        let vc3 = moduleBuilder.build(module: .search)
        vc3.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        
        let vc4 = moduleBuilder.build(module: .downloads)
        vc4.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.circle"), selectedImage: UIImage(systemName: "arrow.down.circle.fill"))
        
        tabBar.tintColor = .label
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
    
    //MARK: - Deinit
    deinit { print("DEALLOCATION: \(Self.self)")}
}
