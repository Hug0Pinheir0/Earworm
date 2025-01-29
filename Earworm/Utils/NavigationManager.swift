//
//  NavigationManager.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import UIKit

class NavigationManager {
    
    static let shared = NavigationManager()
    
    private init() {}

    func showPodcastDetails(from viewController: UIViewController, with feed: RSSFeed) {
        let detailsVC = PodcastDetailsViewController(feed: feed)
        viewController.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func showPlayer(from viewController: UIViewController, with episode: Episode, episodesList: [Episode], startIndex: Int) {
        let playerVC = PlayerViewController(episode: episode, episodeList: episodesList, startIndex: startIndex)
        viewController.navigationController?.pushViewController(playerVC, animated: true)
    }

    func showDownloads(from viewController: UIViewController) {
        let downloadsVC = DownloadsViewController()
        viewController.navigationController?.pushViewController(downloadsVC, animated: true)
    }

    func showFavorites(from viewController: UIViewController) {
        let favoritesVC = FavoritesViewController()
        viewController.navigationController?.pushViewController(favoritesVC, animated: true)
    }
}
