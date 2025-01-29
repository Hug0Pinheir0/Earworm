//
//  PlayerViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import UIKit
import SnapKit

class PlayerViewController: UIViewController {
    
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
        button.addTarget(PlayerViewController.self, action: #selector(playPauseTapped), for: .touchUpInside)
        return button
    }()
    
    private let previousEpisodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.tintColor = .gray
        button.addTarget(PlayerViewController.self, action: #selector(previousEpisodeTapped), for: .touchUpInside)
        return button
    }()
    
    private let nextEpisodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .gray
        button.addTarget(PlayerViewController.self, action: #selector(nextEpisodeTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configureAudioPlayer()
    }
    
    private func configureAudioPlayer() {
        AudioPlayerManager.shared.onProgressUpdate = { [weak self] progress in
            self?.progressBar.setProgress(progress, animated: true)
        }

        AudioPlayerManager.shared.onEpisodeChange = { [weak self] episode in
            self?.updateUI(with: episode)
        }

        if let episode = AudioPlayerManager.shared.getCurrentEpisode() {
            updateUI(with: episode)
        }
    }

    private func updateUI(with episode: Episode) {
        episodeTitleLabel.text = episode.title
        updatePlayPauseButton()
    }

    private func updatePlayPauseButton() {
        let isPlaying = AudioPlayerManager.shared.isPlaying()
        let imageName = isPlaying ? "pause.circle.fill" : "play.circle.fill"
        playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    // MARK: - Actions
    
    @objc private func playPauseTapped() {
        AudioPlayerManager.shared.playPause()
        updatePlayPauseButton()
    }

    @objc private func nextEpisodeTapped() {
        AudioPlayerManager.shared.playNext()
    }

    @objc private func previousEpisodeTapped() {
        AudioPlayerManager.shared.playPrevious()
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

#Preview {
    PlayerViewController()
}

