//
//  FavoriteEpisodeCell.swift
//  Earworm
//
//  Created by Hugo Pinheiro on 30/01/25.
//

import UIKit

class FavoriteEpisodeCell: BaseTableViewCell {
    weak var delegate: FavoriteEpisodeCellDelegate?
    private var episode: Episode?
    
    private let titleLabel: CustomLabel = {
        let label = CustomLabel(text: "", fontSize: 16, textColor: .black, alignment: .center)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)
        
        favoriteButton.setContentHuggingPriority(.required, for: .horizontal)
        favoriteButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-8)
            make.top.bottom.equalToSuperview().inset(10) 
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configure(with item: Any) {
        guard let episode = item as? Episode else { return }
        self.episode = episode
        titleLabel.text = episode.title
        updateFavoriteState()
    }
    
    private func updateFavoriteState() {
        guard let episode = episode else { return }
        let isFavorite = FavoriteManager.shared.isFavorite(episode)
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func favoriteTapped() {
        guard let episode = episode else { return }
        FavoriteManager.shared.toggleFavorite(episode)
        updateFavoriteState()
        delegate?.didToggleFavorite(for: episode)
    }
}

protocol FavoriteEpisodeCellDelegate: AnyObject {
    func didToggleFavorite(for episode: Episode)
}

extension FavoritesViewController: FavoriteEpisodeCellDelegate {
    func didToggleFavorite(for episode: Episode) {
        presenter.loadFavorites()
    }
}
