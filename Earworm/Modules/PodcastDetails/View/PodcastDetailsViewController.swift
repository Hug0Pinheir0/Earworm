//
//  PodcastDetailsViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation
import UIKit
import SnapKit

class PodcastDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private var feed: RSSFeed
    
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

    private let durationLabel = CustomLabel(text: "Duração: 00:00", fontSize: 14, textColor: .gray, alignment: .left)

    private let genreLabel = CustomLabel(text: "Gênero: ", fontSize: 14, textColor: .gray, alignment: .left)

    private let infoStackView: UIStackView = {
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
    }
    
    // MARK: - Setup UI

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(podcastImageView)
        
        infoStackView.addArrangedSubview(descriptionLabel)
        infoStackView.addArrangedSubview(authorsLabel)
        infoStackView.addArrangedSubview(durationLabel)
        infoStackView.addArrangedSubview(genreLabel)
        
        view.addSubview(infoStackView)
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
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(podcastImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func populateUI() {
        titleLabel.text = feed.title
        descriptionLabel.text = feed.description
        authorsLabel.text = "Autores: \(feed.authors)"
        durationLabel.text = feed.episodes.first?.duration.isEmpty == false ? "Duração: \(feed.episodes.first?.duration ?? "N/A")" : "Duração: N/A"
        genreLabel.text = "Gênero: \(feed.category)" // Atualizado para usar "category"
        
        // Carrega a imagem do podcast (exemplo com URL)
        if let url = URL(string: feed.imageURL), let data = try? Data(contentsOf: url) {
            podcastImageView.image = UIImage(data: data)
        }
    }
}
