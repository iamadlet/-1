//
//  MainViewController.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func loadProducts(_ products: [Product])
    func showError(_ message: String)
}

final class MainViewController: UIViewController {
    private lazy var mainView = MainView(presenter: presenter)
    private let presenter: MainPresenterProtocol
    
    private var products: [Product] = []
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        presenter.viewDidLoad()
    }
}

extension MainViewController: MainViewProtocol {
    func loadProducts(_ products: [Product]) {
        self.products = products
        mainView.tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        
        let product = products[indexPath.row]
        cell.configureCell(with: product)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        // TODO: - вызвать метод презентера, который триггерит роутер
        presenter.didSelect(product: product)
    }
}
