//
//  PlayerViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import UIKit
import SnapKit

class PlayerViewController: UIViewController {
    
    // MARK: - Properties
    private var episode: Episode
    private var episodeList: [Episode]
    private var currentIndex: Int

    // MARK: - UI Elements
    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.0
        progressView.tintColor = .systemBlue
        progressView.trackTintColor = .lightGray
        return progressView
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let previousEpisodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private let nextEpisodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .gray
        return button
    }()

    // MARK: - Initializer
    init(episode: Episode, episodeList: [Episode], startIndex: Int) {
        self.episode = episode
        self.episodeList = episodeList
        self.currentIndex = startIndex
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
        setupActions()
        configureAudioPlayer()
        updateUI()
    }

    private func configureAudioPlayer() {
        AudioPlayerManager.shared.onProgressUpdate = { [weak self] progress in
            self?.progressBar.setProgress(progress, animated: true)
        }

        AudioPlayerManager.shared.onEpisodeChange = { [weak self] episode in
            self?.updateUI(with: episode)
        }

        // Iniciar a reprodução do episódio ao abrir a tela
        AudioPlayerManager.shared.play(url: episode.audioURL)
    }

    private func updateUI() {
        episodeTitleLabel.text = episode.title
        updatePlayPauseButton()
    }

    private func updateUI(with episode: Episode) {
        self.episode = episode
        episodeTitleLabel.text = episode.title
        updatePlayPauseButton()
    }

    private func updatePlayPauseButton() {
        let isPlaying = AudioPlayerManager.shared.isPlaying()
        let imageName = isPlaying ? "pause.circle.fill" : "play.circle.fill"
        playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    // MARK: - Actions
    
    private func setupActions() {
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        previousEpisodeButton.addTarget(self, action: #selector(previousEpisodeTapped), for: .touchUpInside)
        nextEpisodeButton.addTarget(self, action: #selector(nextEpisodeTapped), for: .touchUpInside)
    }

    @objc private func playPauseTapped() {
        AudioPlayerManager.shared.playPause()
        updatePlayPauseButton()
    }

    @objc private func nextEpisodeTapped() {
        guard currentIndex < episodeList.count - 1 else { return }
        currentIndex += 1
        let nextEpisode = episodeList[currentIndex]
        AudioPlayerManager.shared.play(url: nextEpisode.audioURL)
        updateUI(with: nextEpisode)
    }

    @objc private func previousEpisodeTapped() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        let previousEpisode = episodeList[currentIndex]
        AudioPlayerManager.shared.play(url: previousEpisode.audioURL)
        updateUI(with: previousEpisode)
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(episodeTitleLabel)
        view.addSubview(progressBar)
        view.addSubview(playPauseButton)
        view.addSubview(previousEpisodeButton)
        view.addSubview(nextEpisodeButton)
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
            make.width.height.equalTo(50)
        }
        
        nextEpisodeButton.snp.makeConstraints { make in
            make.leading.equalTo(playPauseButton.snp.trailing).offset(40)
            make.centerY.equalTo(playPauseButton)
            make.width.height.equalTo(50)
        }
    }
}

