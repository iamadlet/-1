//
//  TransactionCell.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import UIKit
import SnapKit

protocol TransactionCellViewProtocol: AnyObject {
    func configureCell(original: String, converted: String)
}

final class TransactionCell: UITableViewCell {
    static let reuseIdentifier = "TransactionCell"
    private let formatter = CurrencyFormatter()
    private var converter: CurrencyConverter?
    
    struct Model {
        let original: String
        let converted: String
    }
    
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let convertedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TransactionCell: TransactionCellViewProtocol {
//    func configureCell(with transaction: Transaction, rates: [Rate]) {
//        converter = CurrencyConverter(rates: rates)
//        if let converter, let convertedAmount = converter.convert(from: transaction.currency, to: "GBP", amount: transaction.amount) {
//            convertedPriceLabel.text = formatter.format(currency: "GBP", amount: convertedAmount)
//        } else {
//            convertedPriceLabel.text = "—"
//        }
//        originalPriceLabel.text = formatter.format(currency: transaction.currency, amount: transaction.amount)
//    }
    
    func configureCell(original: String, converted: String) {
        originalPriceLabel.text = original
        convertedPriceLabel.text = converted
    }
    
    private func setupSubviews() {
        contentView.addSubview(originalPriceLabel)
        contentView.addSubview(convertedPriceLabel)
    }
    
    private func setupConstraints() {
        originalPriceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        convertedPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
