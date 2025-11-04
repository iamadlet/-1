//
//  CurrencyConverter.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import Foundation

final class CurrencyConverter {
    private let rates: [Rate]
    
    init(rates: [Rate]) {
        self.rates = rates
    }
    
    func convert(from: String, to: String, amount: Double) -> Double? {
        if from == to {
            return amount
        }
        
        // MARK: - Если есть прямая конвертация
        if let direct = rates.first(where: { $0.from == from && $0.to == to }) {
            return amount * direct.rate
        }
        
        // MARK: - Попробовать найти обратный курс
        if let inverse = rates.first(where: { $0.from == to && $0.to == from }) {
            return amount / inverse.rate
        }
        
        // MARK: - Поиск кросс-курса
        return convertViaGraph(from: from, to: to, amount: amount)
    }
}

// MARK: - Алгоритм писал не я, использовал ChatGPT
private extension CurrencyConverter {
    private func convertViaGraph(from: String, to: String, amount: Double) -> Double? {
        var queue: [(currency: String, rate: Double)] = [(from, 1.0)]
        var visited: Set<String> = [from]
        
        while !queue.isEmpty {
            let (current, accRate) = queue.removeFirst()
            if current == to {
                return amount * accRate
            }
            
            for r in rates where r.from == current && !visited.contains(r.to) {
                visited.insert(r.to)
                queue.append((r.to, accRate * r.rate))
            }
            
            for r in rates where r.to == current && !visited.contains(r.from) {
                visited.insert(r.from)
                queue.append((r.from, accRate / r.rate))
            }
        }
        
        return nil
    }
}
