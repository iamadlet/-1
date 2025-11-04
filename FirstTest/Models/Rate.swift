//
//  Rate.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import Foundation

struct RateResponse: Decodable {
    let from: String
    let rate: String
    let to: String
}

struct Rate {
    let from: String
    let rate: Double
    let to: String
}

extension Rate {
    init?(data: RateResponse) {
        guard let rateValue = Double(data.rate) else { return nil }
        self.from = data.from
        self.rate = rateValue
        self.to = data.to
    }
}
