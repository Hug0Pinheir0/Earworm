//
//  EpisodeTableViewCell.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import UIKit

class EpisodeTableViewCell: BaseTableViewCell {
    
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

    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()

    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
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
        
        bottomStackView.addArrangedSubview(durationLabel)
        bottomStackView.addArrangedSubview(playButton)

        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(bottomStackView)

        contentView.addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure(with item: Any) {
        guard let episode = item as? Episode else { return }
        self.episode = episode
        titleLabel.text = episode.title
        durationLabel.text = "Duração: \(episode.duration.toTimeString())"
    }

    @objc private func playButtonTapped() {
        guard let episode = episode else { return }
        delegate?.didTapPlayPause(for: episode, in: self)
    }

    func togglePlayPauseState() {
        isPlaying.toggle()
    }
}
