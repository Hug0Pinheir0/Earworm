//
//  CustomTabBarController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupViewControllers()
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .lightGray

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
    }

    private func setupViewControllers() {
        viewControllers = [
            createNavController(for: RSSFeedViewController(), title: "Feed", image: "doc.text.image"),
            createNavController(for: FavoritesViewController(), title: "Favoritos", image: "heart"),
            createNavController(for: DownloadsViewController(), title: "Downloads", image: "arrow.down.circle")
        ]
    }

    private func createNavController(for rootViewController: UIViewController, title: String, image: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: image), tag: 0)
        return navController
    }
}
