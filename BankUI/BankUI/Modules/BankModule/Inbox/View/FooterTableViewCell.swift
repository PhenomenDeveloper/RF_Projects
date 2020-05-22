//
//  FooterTableViewCell.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class FooterTableViewCell: UITableViewCell {
    static let reuseId = "FooterTableViewCell"

    let alertLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.inboxSubtitleFontSize, weight: .regular)
        label.textColor = ThemeManager.Color.subtitleColor
        label.text = "В истории хранятся все уведомления,\nполученные от Банка за последние 3 месяца"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        overlayFirstLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func overlayFirstLayer() {
        addSubview(alertLabel)

        alertLabel.setPosition(top: topAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: 0,
                             paddingLeft: ConstraintsManager.InboxModule.CardView.leftConstraint,
                             paddingBottom: 0,
                             paddingRight: ConstraintsManager.InboxModule.CardView.rightConstraint,
                             width: 0,
                             height: 0)
    }

}
