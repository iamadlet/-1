//
//  DetailPresenter.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    var title: String { get }
    var header: String { get }
    
    func viewDidLoad()
    func convertTransactions(_ transactions: [Transaction]) -> [Transaction]
    func sumAmount(of transactions: [Transaction]) -> String
    func formatTransaction(transaction: Transaction) -> String
}

final class DetailPresenter {
    weak var view: DetailViewProtocol?
    
    private let rateService: RateServiceProtocol
    private let context: DetailFactory.Context
    private let formatter: CurrencyFormatter
    private var rates: [Rate] = []
    private var converter: CurrencyConverter?
    
    init(rateService: RateServiceProtocol, context: DetailFactory.Context, formatter: CurrencyFormatter) {
        self.rateService = rateService
        self.context = context
        self.formatter = formatter
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func formatTransaction(transaction: Transaction) -> String {
        formatter.format(currency: transaction.currency, amount: transaction.amount)
    }
    
    func convertTransactions(_ transactions: [Transaction]) -> [Transaction] {
        guard let converter else { return transactions }
        
        var convertedTransactions: [Transaction] = []
        transactions.forEach { transaction in
            // TODO: Логика такая - прохожусь по каждой транзакции, конвертирую в нужную мне валюту. Можно эту валюту даже в вводный параметр засунуть.
            if transaction.currency != "GBP" {
                if let convertedAmount = converter.convert(from: transaction.currency, to: "GBP", amount: transaction.amount) {
                    let convertedTransaction = Transaction(
                        amount: convertedAmount,
                        currency: "GBP",
                        sku: transaction.sku
                    )
                    convertedTransactions.append(convertedTransaction)
                }
            } else {
                convertedTransactions.append(transaction)
            }
        }
        
        return convertedTransactions
    }
    
    func sumAmount(of transactions: [Transaction]) -> String {
        let sum = transactions.reduce(0) { $0 + $1.amount }
        return String(format: "£%.2f", sum)
    }
    
    var title: String { "Transactions for \(context.product.sku)" }
    
    var header: String { "Total: \(sumAmount(of: convertTransactions(context.product.transactions)))" }
    
    func viewDidLoad() {
        // MARK: - 1. Грузим все курсы
        rateService.loadRates { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let rates):
                    self.rates = rates
                    self.converter = CurrencyConverter(rates: rates)
                    self.view?.loadRates(rates)
                    self.view?.loadOriginalTransactions(self.context.product.transactions)
                    self.view?.loadConvertedTransactions(self.convertTransactions(self.context.product.transactions))
                    // TODO: - Добавить вызов метода prepareTransactions(), который будет конвертировать валюту в нужную
                case .failure(let error):
                    self.view?.showError("Failed to load rates, \(error)")
                }
            }
        }
    }
}
