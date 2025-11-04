//
//  MainFactory.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import UIKit

final class MainFactory {
    func make() -> UIViewController {
        let service = TransactionsService(plistLoader: PlistLoader())
        
        let router = MainRouter()
        
        let presenter = MainPresenter(router: router, transactionService: service)
        
        let vc = MainViewController(presenter: presenter)
        
        presenter.view = vc
        router.view = vc
        
        return vc
    }
}
