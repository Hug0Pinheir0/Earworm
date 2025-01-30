//
//
//  FavoritesViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import UIKit
import SnapKit

class FavoritesViewController: BaseTableViewController<Episode, FavoriteEpisodeCell> {
    
    // MARK: - Properties
    var presenter: FavoritesPresenter!

    private let titleLabel: CustomLabel = {
        return CustomLabel(text: "Favoritos", fontSize: 24, textColor: .black, alignment: .center)
    }()
    
    private let emptyStateLabel: CustomLabel = {
        return CustomLabel(text: "Nenhum episódio favoritado", fontSize: 16, textColor: .gray, alignment: .center)
    }()
    
    private let contentView = UIView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter = FavoritesPresenter(view: self)
        presenter.loadFavorites()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavorites), name: NSNotification.Name("FavoritesUpdated"), object: nil)

    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        view.addSubview(emptyStateLabel)
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        emptyStateLabel.isHidden = true
    }
    
    override func configureTableConstraints() {
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Implementação do protocolo FavoritesViewProtocol
    func showFavorites(_ episodes: [Episode]) {
        self.items = episodes
        tableView.isHidden = false
        emptyStateLabel.isHidden = true
        tableView.reloadData()
    }

    func showEmptyState() {
        self.items.removeAll()
        tableView.isHidden = true
        emptyStateLabel.isHidden = false
    }

    override func configureCell(_ cell: FavoriteEpisodeCell, with item: Episode) {
        cell.configure(with: item)
        cell.delegate = self
    }
    
    @objc private func reloadFavorites() {
        presenter.loadFavorites()
    }
}

// MARK: - FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {}
