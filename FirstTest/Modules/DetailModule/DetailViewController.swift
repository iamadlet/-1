//
//  DetailView.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    func loadRates(_ rates: [Rate])
    func loadOriginalTransactions(_ transactions: [Transaction])
    func loadConvertedTransactions(_ transactions: [Transaction])
    func showError(_ message: String)
}

final class DetailViewController: UIViewController {
    private lazy var detailView = DetailView(presenter: presenter)
    private let presenter: DetailPresenterProtocol
    
    private var originalTransactions: [Transaction] = []
    private var convertedTransactions: [Transaction] = []
    private var rates: [Rate] = []
    
    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = presenter.title
        detailView.tableView.dataSource = self
        detailView.tableView.delegate = self
        presenter.viewDidLoad()
    }
    
}

extension DetailViewController: DetailViewProtocol {
    func loadRates(_ rates: [Rate]) {
        self.rates = rates
        detailView.tableView.reloadData()
    }
    
    func loadOriginalTransactions(_ transactions: [Transaction]) {
        self.originalTransactions = transactions
        detailView.tableView.reloadData()
    }
    
    func loadConvertedTransactions(_ transactions: [Transaction]) {
        self.convertedTransactions = transactions
        detailView.tableView.reloadData()
    }
    
    func showError(_ message: String) {
        
    }
}


extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        originalTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as? TransactionCell else {
            return UITableViewCell()
        }
        
        let originalTransaction = originalTransactions[indexPath.row]
        let convertedTransaction = convertedTransactions[indexPath.row]
        let cellModel = TransactionCell.Model(
            original: presenter.formatTransaction(transaction: originalTransaction),
            converted: presenter.formatTransaction(transaction: convertedTransaction)
        )
        // TODO: - Переписать метод configureCell(), чтобы принимал 2 параметра: оригинальную и конвертированную транзакцию, уже в виде стринга
        cell.configureCell(original: cellModel.original, converted: cellModel.converted)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.header
    }
    
    
}
