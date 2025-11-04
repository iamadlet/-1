//
//  FirstTestTests.swift
//  FirstTestTests
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import XCTest
@testable import FirstTest

final class MockRateService: RateServiceProtocol {
    var result: Result<[Rate], PlistLoaderError>?
    
    func loadRates(completion: @escaping (Result<[Rate], PlistLoaderError>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}

final class MockView: DetailViewProtocol {
    var didLoadRates = false
    var didShowError = false
    var didLoadOriginalTransactions = false
    var didLoadConvertedTransactions = false
    
    func loadRates(_ rates: [Rate]) {
        didLoadRates = true
    }
    
    func loadOriginalTransactions(_ transactions: [Transaction]) {
        didLoadOriginalTransactions = true
    }
    
    func loadConvertedTransactions(_ transactions: [Transaction]) {
        didLoadConvertedTransactions = true
    }
    
    func showError(_ message: String) {
        didShowError = true
    }
}

final class DetailPresenterTests: XCTestCase {
    var presenter: DetailPresenter!
    var mockService: MockRateService!
    var mockView: MockView!
    
    override func setUp() {
        super.setUp()
        mockService = MockRateService()
        mockView = MockView()
        
        let context = DetailFactory.Context(product: Product(
            sku: "TST123",
            transactions: [
                Transaction(amount: 10, currency: "USD", sku: "TST123"),
                Transaction(amount: 5, currency: "GBP", sku: "TST123")
            ]
        ))
        
        presenter = DetailPresenter(rateService: mockService,
                                    context: context,
                                    formatter: CurrencyFormatter())
        presenter.view = mockView
    }
    
    func testConvertTransactions_ConvertsUSDToGBP() {
        // GIVEN
        let rates = [Rate(from: "USD", rate: 0.8, to: "GBP")]
        presenter.convertTransactions([])
        let converter = CurrencyConverter(rates: rates)
        
        // WHEN
        let result = converter.convert(from: "USD", to: "GBP", amount: 10)
        
        // THEN
        XCTAssertEqual(result!, 8.0, accuracy: 0.0001)
    }
    
    func testViewDidLoad_WhenRatesLoadSuccessfully_CallsLoadRates() {
        // GIVEN
        let rates = [Rate(from: "USD", rate: 0.8, to: "GBP")]
        mockService.result = .success(rates)
        
        let expectation = XCTestExpectation(description: "Wait for rates to load")
        
        // WHEN
        presenter.viewDidLoad()
        
        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockView.didLoadRates)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

