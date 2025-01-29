//
//  BaseTableViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import UIKit
import SnapKit

class BaseTableViewController<T, Cell: BaseTableViewCell>: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var items: [T] = []
    let tableView = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        configureCell(cell, with: items[indexPath.row])
        return cell
    }
    
    // MARK: - Métodos personalizáveis
    func configureCell(_ cell: Cell, with item: T) { }
    func didSelectItem(_ item: T, at indexPath: IndexPath) { }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItem(items[indexPath.row], at: indexPath)
    }
}
