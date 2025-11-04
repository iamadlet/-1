//
//  ProductCell.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import UIKit
import SnapKit

final class ProductCell: UITableViewCell {
    static let reuseIdentifier = "ProductCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let arrowImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        image.tintColor = .tertiaryLabel
        return image
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

extension ProductCell {
    func configureCell(with product: Product) {
        nameLabel.text = product.sku
        countLabel.text = "\(product.transactions.count) transactions"
    }
    
    private func setupSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(arrowImage)
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        arrowImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.trailing.equalTo(arrowImage.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
    }
}
