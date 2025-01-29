//
//  PodcastDetailsViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class PodcastDetailsViewController: BaseTableViewController<Episode, EpisodeTableViewCell> {
    
    // MARK: - Properties
    private var feed: RSSFeed
    private var currentlyPlayingCell: EpisodeTableViewCell?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = CustomLabel(text: "Título do Podcast", fontSize: 24, textColor: .black, alignment: .center)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()

    private let podcastImageView: UIImageView = {
        let imageView = CustomImageView(cornerRadius: 10, contentMode: .scaleAspectFit)
        imageView.backgroundColor = .lightGray // Placeholder
        return imageView
    }()

    private let descriptionLabel = CustomLabel(text: "Descrição do Podcast", fontSize: 16, textColor: .darkGray, alignment: .left)

    private let authorsLabel = CustomLabel(text: "Autores: John Doe", fontSize: 14, textColor: .gray, alignment: .left)

    private let genreLabel = CustomLabel(text: "Gênero: ", fontSize: 14, textColor: .gray, alignment: .left)

    private let podcastDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // MARK: - Initializer
    init(feed: RSSFeed) {
        self.feed = feed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        populateUI()
        items = feed.episodes
        tableView.reloadData()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(podcastImageView)

        // Adiciona labels nas stack views
        podcastDetailsStackView.addArrangedSubview(descriptionLabel)
        podcastDetailsStackView.addArrangedSubview(authorsLabel)
        podcastDetailsStackView.addArrangedSubview(genreLabel)

        view.addSubview(podcastDetailsStackView)
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        podcastImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        podcastDetailsStackView.snp.makeConstraints { make in
            make.top.equalTo(podcastImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(podcastDetailsStackView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }

    private func populateUI() {
        titleLabel.text = feed.title
        descriptionLabel.text = feed.description
        authorsLabel.text = "Autores: \(feed.authors)"
        genreLabel.text = "Gênero: \(feed.category)"
        
        if let url = URL(string: feed.imageURL) {
            podcastImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(named: "placeholder"),
                options: [.continueInBackground, .highPriority]
            )
        }
    }

    override func configureCell(_ cell: EpisodeTableViewCell, with item: Episode) {
        cell.configure(with: item)
        cell.delegate = self
    }

    override func didSelectItem(_ item: Episode, at indexPath: IndexPath) {
        let selectedEpisode = feed.episodes[indexPath.row]
        NavigationManager.shared.showPlayer(from: self, with: selectedEpisode, episodesList: feed.episodes, startIndex: indexPath.row)
    }
}

// MARK: - EpisodePlaybackDelegate
extension PodcastDetailsViewController: EpisodePlaybackDelegate {
    func didTapPlayPause(for episode: Episode, in cell: EpisodeTableViewCell) {
        if AudioPlayerManager.shared.isPlaying() {
            AudioPlayerManager.shared.pause()
            currentlyPlayingCell?.togglePlayPauseState()
            currentlyPlayingCell = nil
        } else {
            AudioPlayerManager.shared.play(url: episode.audioURL)
            currentlyPlayingCell?.togglePlayPauseState()
            currentlyPlayingCell = cell
            currentlyPlayingCell?.togglePlayPauseState()
        }
    }
}
