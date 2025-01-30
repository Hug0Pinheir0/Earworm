//
//  FavoritesPresenter.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 30/01/25.
//

import Foundation

class FavoritesPresenter {
    private weak var view: FavoritesViewProtocol?

    init(view: FavoritesViewProtocol) {
        self.view = view
        NotificationCenter.default.addObserver(self, selector: #selector(loadFavorites), name: .didUpdateFavorites, object: nil)
    }

    @objc func loadFavorites() {
        let favoriteEpisodes = FavoriteManager.shared.getFavorites()
        
        if favoriteEpisodes.isEmpty {
            view?.showEmptyState()
        } else {
            view?.showFavorites(favoriteEpisodes)
        }
    }
}




