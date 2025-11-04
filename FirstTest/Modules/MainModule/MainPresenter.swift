//
//  MainPresenter.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    var title: String { get }
    
    func viewDidLoad()
    func makeProducts(from: [Transaction]) -> [Product]
    func didSelect(product: Product)
}

final class MainPresenter {
    weak var view: MainViewProtocol?
    
    private let router: MainRouterProtocol
    private let transactionService: TransactionServiceProtocol
    
    private var products: [Product] = []
    
    init(router: MainRouterProtocol, transactionService: TransactionServiceProtocol) {
        self.router = router
        self.transactionService = transactionService
    }
    
    
    
    
}

extension MainPresenter: MainPresenterProtocol {
    var title: String {
        "Products"
    }
    
    func viewDidLoad() {
        transactionService.loadTransactions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    self?.products = self?.makeProducts(from: transactions) ?? []
                    self?.view?.loadProducts(self?.products ?? [])
                case .failure(let error):
                    self?.view?.showError("Failed to load transactions, \(error)")
                }
            }
        }
    }
    
    func makeProducts(from transactions: [Transaction]) -> [Product] {
        let grouped = Dictionary(grouping: transactions, by: { $0.sku })
        return grouped.map { key, value in
            Product(sku: key, transactions: value)
        }.sorted(by: { $0.sku < $1.sku })
    }
    
    func didSelect(product: Product) {
        router.openDetailModule(for: product)
    }
}
