//
//  MainTabVC.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let photosVC = UnsplashVC(collectionViewLayout: UICollectionViewFlowLayout())
        
//        let albumVC = AlbumVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        viewControllers = [
            generateNavigationController(rootViewController: photosVC, title: "Photos", image: #imageLiteral(resourceName: "photos")),
//            generateNavigationController(rootViewController: albumVC, title: "Favourites", image: #imageLiteral(resourceName: "heart"))
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
