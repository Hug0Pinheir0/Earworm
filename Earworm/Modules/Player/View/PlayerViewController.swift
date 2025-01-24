//
//  PlayerViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation
import UIKit
import SnapKit

class PlayerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Título do Episódio"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.3 // Placeholder progress
        progressView.tintColor = .systemBlue
        progressView.trackTintColor = .lightGray
        return progressView
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    private let previousEpisodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("◀", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    private let nextEpisodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    
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
            make.width.height.equalTo(50)
        }
        
        previousEpisodeButton.snp.makeConstraints { make in
            make.trailing.equalTo(playPauseButton.snp.leading).offset(-20)
            make.centerY.equalTo(playPauseButton)
            make.width.height.equalTo(50)
        }
        
        nextEpisodeButton.snp.makeConstraints { make in
            make.leading.equalTo(playPauseButton.snp.trailing).offset(20)
            make.centerY.equalTo(playPauseButton)
            make.width.height.equalTo(50)
        }
    }
}
