//
//  RateService.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import Foundation

protocol RateServiceProtocol: AnyObject {
    func loadRates(
        completion: @escaping (Result<[Rate], PlistLoaderError>) -> Void
    )
}

final class RateService: RateServiceProtocol {
    private let plistLoader: PlistLoaderProtocol
    
    init(plistLoader: PlistLoaderProtocol) {
        self.plistLoader = plistLoader
    }
    
    func loadRates(completion: @escaping (Result<[Rate], PlistLoaderError>) -> Void) {
        plistLoader.loadData(named: "rates") { (result: Result<[RateResponse], PlistLoaderError>) in
            switch result {
            case .success(let response):
                let rates = response.compactMap { Rate(data: $0) }
                completion(.success(rates))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
