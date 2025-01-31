//
//  RSSFeedViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import UIKit
import SnapKit
import SDWebImage

class RSSFeedViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let cardView = CustomCardView()

    private let titleLabel: CustomLabel = {
        let label = CustomLabel(
            text: "Insira aqui a URL do RSS",
            fontSize: 20,
            textColor: .black,
            alignment: .center
        )
        return label
    }()
    
    private let urlTextField: CustomTextField = {
        let textField = CustomTextField(
            placeholder: "Digite a URL do RSS"
        )
        return textField
    }()

    private let submitButton: CustomButton = {
        let button = CustomButton(
            title: "Buscar",
            backgroundColor: .systemBlue
        )
        return button
    }()
    
    private lazy var clearCacheButton = CustomButton(
        title: "Limpar Cache",
        backgroundColor: .red,
        action: {
            SDImageCache.shared.clear(with: .all) {
                print("🗑 Cache Imagem limpo!")
            }

            if let urlString = self.urlTextField.text, !urlString.isEmpty {
                RSSCacheManager.clear(for: urlString)
                print("🗑 Cache do RSS para \(urlString) limpo!")
            } else {
                print("⚠️ Nenhuma URL válida inserida para limpar o cache.")
            }
        }
    )

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Properties
    var presenter: RSSFeedPresenter?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RSSFeedPresenter(view: self)
        setupUI()
        setupConstraints()
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(cardView)

        cardView.addSubview(titleLabel)
        cardView.addSubview(urlTextField)
        cardView.addSubview(buttonStackView)

        buttonStackView.addArrangedSubview(submitButton)
        buttonStackView.addArrangedSubview(clearCacheButton)
    }
    
    private func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.greaterThanOrEqualTo(180)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(urlTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Actions
    @objc private func submitButtonTapped() {
        presenter?.handleSubmitButtonTapped(with: urlTextField.text)
    }
}

// MARK: - RSSFeedViewProtocol
extension RSSFeedViewController: RSSFeedViewProtocol {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateUI(with feed: RSSFeed) {
        DispatchQueue.main.async {
            self.presenter?.navigateToDetails(with: feed)
        }
    }
}

#Preview {
    let vc = RSSFeedViewController()
    return vc
}
