//
//  TransactionsService.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import Foundation

protocol TransactionServiceProtocol: AnyObject {
    func loadTransactions(
        completion: @escaping (Result<[Transaction], PlistLoaderError>) -> Void
    )
}

final class TransactionsService: TransactionServiceProtocol {
    private let plistLoader: PlistLoaderProtocol
    
    init(plistLoader: PlistLoaderProtocol) {
        self.plistLoader = plistLoader
    }
    
    func loadTransactions(completion: @escaping (Result<[Transaction], PlistLoaderError>) -> Void) {
        plistLoader.loadData(named: "transactions") { (result: Result<[TransactionResponse], PlistLoaderError>) in
            switch result {
            case .success(let response):
                let transactions = response.compactMap { Transaction(data: $0) }
                completion(.success(transactions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
