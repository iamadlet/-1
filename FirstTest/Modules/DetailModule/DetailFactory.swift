//
//  DetailFactory.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import UIKit

final class DetailFactory {
    struct Context {
        let product: Product
    }
    
    func make(with context: Context) -> UIViewController {
        let rateService = RateService(plistLoader: PlistLoader())
        let formatter = CurrencyFormatter()
        
        let presenter = DetailPresenter(
            rateService: rateService,
            context: context,
            formatter: formatter
        )
        
        let vc = DetailViewController(presenter: presenter)
        presenter.view = vc
        
        return vc
    }
}
