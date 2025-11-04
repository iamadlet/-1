//
//  MainRouter.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import UIKit

protocol MainRouterProtocol: AnyObject {
    func openDetailModule(for product: Product)
}

final class MainRouter: MainRouterProtocol {
    weak var view: UIViewController?
    
    func openDetailModule(for product: Product) {
        let context = DetailFactory.Context(product: product)
        let detailVC = DetailFactory().make(with: context)
        view?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
