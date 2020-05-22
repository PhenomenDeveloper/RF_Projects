//
//  BaseBottomCardCell.swift
//  BankUI
//
//  Created by Lev Kolesnikov on 20.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

protocol BaseBottomCardCellProtocol {
    func overlayFirstLayer()
    func overlaySecondLayer()
}

class BaseBottomCardCell: UITableViewCell, BaseBottomCardCellProtocol {

    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view

    }()

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        overlayFirstLayer()
        overlaySecondLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func overlayFirstLayer() {
        addSubview(cardView)
        cardView.backgroundColor = .white
        cardView.setPosition(top: topAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: 0,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 0,
                             height: 0)
    }

    func overlaySecondLayer() {

    }
}
