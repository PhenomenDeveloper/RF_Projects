//
//  SecondCell.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 17.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class ATMAddressTableViewCell: BaseBottomCardCell {
    static let reuseId = "ATMAddressTableViewCell"

    let addressTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Адрес"
        label.textColor = #colorLiteral(red: 0.5999458432, green: 0.600034833, blue: 0.5999264717, alpha: 1)

        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.accessibilityIdentifier = "BottomCardAddress"
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func overlayFirstLayer() {
        super.overlayFirstLayer()
    }

    override func overlaySecondLayer() {

        cardView.addSubview(addressTitleLabel)
        addressTitleLabel.setPosition(top: cardView.topAnchor,
                                      left: cardView.leftAnchor,
                                      bottom: nil,
                                      right: nil,
                                      paddingTop: 12,
                                      paddingLeft: 16,
                                      paddingBottom: 0,
                                      paddingRight: 0,
                                      width: 0,
                                      height: 0)

        cardView.addSubview(addressLabel)
        addressLabel.setPosition(top: addressTitleLabel.bottomAnchor,
                                 left: addressTitleLabel.leftAnchor,
                                 bottom: cardView.bottomAnchor,
                                 right: cardView.rightAnchor,
                                 paddingTop: 8,
                                 paddingLeft: 0,
                                 paddingBottom: 12,
                                 paddingRight: 28,
                                 width: 0,
                                 height: 0)

    }

}
