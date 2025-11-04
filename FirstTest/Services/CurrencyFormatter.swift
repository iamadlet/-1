//
//  CurrencyFormatter.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import Foundation

final class CurrencyFormatter {
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
        
    }()
    
    func format(currency: String, amount: Double) -> String {
        let locale = locale(for: currency)
        formatter.locale = locale
        formatter.currencyCode = currency
        
        guard var formatted = formatter.string(from: NSNumber(value: amount)) else {
            return "\(currency) \(String(format: "%.2f", amount))"
        }
        
        let symbol = locale.currencySymbol ?? currency
        
        switch currency {
        case "USD", "GBP", "EUR", "JPY":
            // обычные валюты без префикса
            return formatted
            
        default:
            // Если символ — $, добавим корректный префикс по валюте
            if symbol == "$" {
                let prefix = currencyPrefix(for: currency)
                if let range = formatted.range(of: symbol) {
                    formatted.replaceSubrange(range, with: "\(prefix)$")
                }
            }
            return formatted
        }
    }
    
    private func locale(for currency: String) -> Locale {
        for identifier in Locale.availableIdentifiers {
            let locale = Locale(identifier: identifier)
            if locale.currency?.identifier == currency {
                return locale
            }
        }
        return Locale(identifier: "en_GB")
    }
    
    private func currencyPrefix(for currency: String) -> String {
        switch currency {
        case "CAD": return "CA"  // Canadian Dollar → CA$
        case "AUD": return "AU"  // Australian Dollar → AU$
        case "NZD": return "NZ"  // New Zealand Dollar → NZ$
        case "SGD": return "SG"  // Singapore Dollar → SG$
        case "HKD": return "HK"  // Hong Kong Dollar → HK$
        default: return currency.prefix(2).uppercased()
        }
    }
}
