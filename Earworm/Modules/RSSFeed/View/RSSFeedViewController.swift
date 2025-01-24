//
//  RSSFeedViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import UIKit
import SnapKit

class RSSFeedViewController: UIViewController {
    
    // MARK: - UI Elements
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(urlTextField)
        view.addSubview(submitButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(urlTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
    }
}

#Preview {
  let vc = RSSFeedViewController()
    return vc
}


