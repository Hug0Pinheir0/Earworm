//
//  FavoriteProtocol.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 30/01/25.
//

import Foundation

protocol FavoritesViewProtocol: AnyObject {
    func showFavorites(_ episodes: [Episode])
    func showEmptyState()
}
