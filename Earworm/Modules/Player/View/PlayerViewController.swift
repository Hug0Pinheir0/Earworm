//
//  PlayerViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import UIKit
import SnapKit

class PlayerViewController: UIViewController, PlayerViewProtocol {
 
    

    // MARK: - Properties
    private var presenter: PlayerPresenter
    private var episode: Episode

    // MARK: - UI Elements
    
    private let cardView: CustomCardView = {
        let view = CustomCardView()
        return view
    }()
    
    private let episodeTitleLabel: CustomLabel = {
        let label = CustomLabel(text: "", fontSize: 18, textColor: .black, alignment: .center)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var favoriteButton: CustomButton = {
        let button = CustomButton(title: "", backgroundColor: .clear)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return button
    }()

    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.0
        progressView.tintColor = .systemBlue
        progressView.trackTintColor = .lightGray
        return progressView
    }()
    
    private let playPauseButton = UIButton(type: .system)
    private let previousEpisodeButton = UIButton(type: .system)
    private let nextEpisodeButton = UIButton(type: .system)
    
    private let downloadButton = CustomButton(
        title: "Baixar EP",
        backgroundColor: .systemBlue,
        cornerRadius: 10, textColor: .white,
        image: UIImage(systemName: "arrow.down.circle"),
        action: {
            print("Download button tapped!")
        }
    )


    // MARK: - Initializer
    init(episode: Episode, episodeList: [Episode], startIndex: Int) {
         self.episode = episode
         self.presenter = PlayerPresenter(view: nil, episode: episode, episodeList: episodeList, startIndex: startIndex)
         super.init(nibName: nil, bundle: nil)
         self.presenter = PlayerPresenter(view: self, episode: episode, episodeList: episodeList, startIndex: startIndex)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        presenter.checkDownloadStatus()
        presenter.startPlayback()
        updateFavoriteState()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white

        playPauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        playPauseButton.tintColor = .systemBlue
        
        previousEpisodeButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextEpisodeButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)

        view.addSubview(episodeTitleLabel)
        view.addSubview(favoriteButton)
        view.addSubview(progressBar)
        view.addSubview(playPauseButton)
        view.addSubview(previousEpisodeButton)
        view.addSubview(nextEpisodeButton)
        view.addSubview(downloadButton)
    }

    private func setupConstraints() {
           episodeTitleLabel.snp.makeConstraints { make in
               make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
               make.leading.trailing.equalToSuperview().inset(16)
           }

           progressBar.snp.makeConstraints { make in
               make.top.equalTo(episodeTitleLabel.snp.bottom).offset(20)
               make.leading.trailing.equalToSuperview().inset(16)
           }

           playPauseButton.snp.makeConstraints { make in
               make.centerX.equalToSuperview()
               make.top.equalTo(progressBar.snp.bottom).offset(40)
               make.width.height.equalTo(60)
           }

           previousEpisodeButton.snp.makeConstraints { make in
               make.trailing.equalTo(playPauseButton.snp.leading).offset(-40)
               make.centerY.equalTo(playPauseButton)
           }

           nextEpisodeButton.snp.makeConstraints { make in
               make.leading.equalTo(playPauseButton.snp.trailing).offset(40)
               make.centerY.equalTo(playPauseButton)
           }

           downloadButton.snp.makeConstraints { make in
               make.top.equalTo(playPauseButton.snp.bottom).offset(30)
               make.centerX.equalToSuperview()
               make.width.equalTo(200)
               make.height.equalTo(50)
           }
           
           favoriteButton.snp.makeConstraints { make in
               make.leading.equalTo(downloadButton.snp.trailing).offset(20)
               make.centerY.equalTo(downloadButton)
           }
       }

    private func setupActions() {
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        previousEpisodeButton.addTarget(self, action: #selector(previousEpisodeTapped), for: .touchUpInside)
        nextEpisodeButton.addTarget(self, action: #selector(nextEpisodeTapped), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    
    @objc private func playPauseTapped() {
        presenter.togglePlayPause()
    }

    @objc private func previousEpisodeTapped() {
        presenter.previousEpisode()
    }

    @objc private func nextEpisodeTapped() {
        presenter.nextEpisode()
    }

    @objc private func downloadTapped() {
        presenter.downloadEpisode()
    }
    
    @objc private func favoriteTapped() {
        FavoriteManager.shared.toggleFavorite(episode)
        updateFavoriteState()
    }


    
    private func updateFavoriteState() {
            let isFavorite = FavoriteManager.shared.isFavorite(episode)
            let imageName = isFavorite ? "heart.fill" : "heart"
            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    
    func updateProgress(_ progress: Float) {
        DispatchQueue.main.async {
            self.progressBar.setProgress(progress, animated: true)
        }
    }

    func updatePlayPauseButton(isPlaying: Bool) {
        let imageName = isPlaying ? "pause.circle.fill" : "play.circle.fill"
        playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func updateUI(with episode: Episode) {
        self.episode = episode
        episodeTitleLabel.text = episode.title
        updatePlayPauseButton(isPlaying: AudioPlayerManager.shared.isPlaying())
    }


    func updateDownloadButton(isDownloaded: Bool) {
        if isDownloaded {
            downloadButton.setTitle("Baixado", for: .normal)
            downloadButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            downloadButton.backgroundColor = .gray
        } else {
            downloadButton.setTitle("Baixar EP", for: .normal)
            downloadButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
            downloadButton.backgroundColor = .systemBlue
        }
    }

    func showDownloadCompletion() {
        updateDownloadButton(isDownloaded: true)
        let alert = UIAlertController(title: "Download Completo", message: "Episódio adicionado aos downloads!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func showDownloadError(_ message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
