//
//  InboxTableViewCell.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell {
    static let reuseId = "InboxTableViewCell"

    var statement: NetwrokHistoryModel? {
        didSet {

            guard let statement = statement else {return}

            let timeFormater: DateFormatter = DateFormatter()
            timeFormater.dateFormat = "hh:mm"

            operationTypeLabel.text = statement.title
            nameLabel.text = statement.body
            time.text = "\(timeFormater.string(from: statement.sendAt))"
        }
    }

    // MARK: - Создание объектов кастомной ячейки

    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let operationTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.inboxTitleFontSize, weight: .semibold)
        label.textColor = ThemeManager.Color.titleColor

        return label
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.inboxSubtitleFontSize, weight: .regular)
        label.textColor = ThemeManager.Color.titleColor

        return label
    }()

    let time: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.inboxTimeFontSize, weight: .regular)
        label.textColor = ThemeManager.Color.subtitleColor

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        cardView.layer.cornerRadius = ThemeManager.Corner.cardViewCornerRadius
        cardView.clipsToBounds = true

        overlayFirstLayer()
        overlaySecondLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///Наложение первого слоя UI
    private func overlayFirstLayer() {
        addSubview(cardView)

        cardView.setPosition(top: topAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: ConstraintsManager.InboxModule.CardView.topConstraint,
                             paddingLeft: ConstraintsManager.InboxModule.CardView.leftConstraint,
                             paddingBottom: ConstraintsManager.InboxModule.CardView.bottomConstraint,
                             paddingRight: ConstraintsManager.InboxModule.CardView.rightConstraint,
                             width: 0,
                             height: 0)
    }

    ///Наложение второго слоя UI
    private func overlaySecondLayer() {

        cardView.addSubview(operationTypeLabel)
        cardView.addSubview(time)
        cardView.addSubview(nameLabel)

        time.setPosition(top: cardView.topAnchor,
                         left: nil,
                         bottom: nil,
                         right: cardView.rightAnchor,
                         paddingTop: ConstraintsManager.InboxModule.TimeLabel.topConstraint,
                         paddingLeft: ConstraintsManager.InboxModule.TimeLabel.leftConstraint,
                         paddingBottom: ConstraintsManager.InboxModule.TimeLabel.bottomConstraint,
                         paddingRight: ConstraintsManager.InboxModule.TimeLabel.rightConstraint,
                         width: 0,
                         height: 0)

        operationTypeLabel.setPosition(top: cardView.topAnchor,
                                       left: cardView.leftAnchor,
                                       bottom: nil,
                                       right: cardView.rightAnchor,
                                       paddingTop: ConstraintsManager.InboxModule.OperationTypeLabel.topConstraint,
                                       paddingLeft: ConstraintsManager.InboxModule.OperationTypeLabel.leftConstraint,
                                       paddingBottom: ConstraintsManager.InboxModule.OperationTypeLabel.bottomConstraint,
                                       paddingRight: ConstraintsManager.InboxModule.OperationTypeLabel.rightConstraint,
                                       width: 0,
                                       height: 0)

        nameLabel.setPosition(top: operationTypeLabel.bottomAnchor,
                              left: operationTypeLabel.leftAnchor,
                              bottom: cardView.bottomAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: ConstraintsManager.InboxModule.NameLabel.topConstraint,
                              paddingLeft: ConstraintsManager.InboxModule.NameLabel.leftConstraint,
                              paddingBottom: ConstraintsManager.InboxModule.NameLabel.bottomConstraint,
                              paddingRight: ConstraintsManager.InboxModule.NameLabel.rightConstraint,
                              width: 0,
                              height: 0)
    }
}
