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

class PodcastDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private var feed: RSSFeed
    private let episodesTableView = UITableView() // Tabela para listar os episódios
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
        configureTableView()
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
        view.addSubview(episodesTableView)
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

        episodesTableView.snp.makeConstraints { make in
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


    private func configureTableView() {
        episodesTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: EpisodeTableViewCell.identifier)
        episodesTableView.dataSource = self
        episodesTableView.delegate = self
        episodesTableView.rowHeight = UITableView.automaticDimension
        episodesTableView.estimatedRowHeight = 100
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PodcastDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.identifier, for: indexPath) as? EpisodeTableViewCell else {
            return UITableViewCell()
        }
        let episode = feed.episodes[indexPath.row]
        cell.configure(with: episode)
        cell.delegate = self
        return cell
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let selectedEpisode = feed.episodes[indexPath.row]
            let playerVC = PlayerViewController(episode: selectedEpisode, episodeList: feed.episodes, startIndex: indexPath.row)
            navigationController?.pushViewController(playerVC, animated: true)
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

// MARK: - EpisodeTableViewCell
class EpisodeTableViewCell: UITableViewCell {
    
    static let identifier = "EpisodeTableViewCell"
    weak var delegate: EpisodePlaybackDelegate?

    private let titleLabel = CustomLabel(text: "", fontSize: 16, textColor: .black, alignment: .left)
    private let durationLabel = CustomLabel(text: "", fontSize: 14, textColor: .gray, alignment: .right)
    
    private var episode: Episode?
    
    private lazy var playButton: CustomButton = {
        let button = CustomButton(title: "", backgroundColor: .clear)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()

    private var isPlaying = false {
        didSet {
            let imageName = isPlaying ? "pause.circle.fill" : "play.circle.fill"
            playButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        playButton.tintColor = .systemBlue
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(durationLabel)
        stackView.addArrangedSubview(playButton)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with episode: Episode) {
        self.episode = episode
        titleLabel.text = episode.title
        durationLabel.text = "Duração: \(episode.duration)"
    }

    @objc private func playButtonTapped() {
        guard let episode = episode else { return }
        delegate?.didTapPlayPause(for: episode, in: self)
    }

    func togglePlayPauseState() {
        isPlaying.toggle()
    }
}



