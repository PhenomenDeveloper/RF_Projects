//
//  TableViewCell.swift
//  TableView
//
//  Created by MANVELYAN Gevorg on 16.01.2020.
//  Copyright © 2020 MANVELYAN Gevorg. All rights reserved.
//

import UIKit

class SubwayListTableviewCell: UITableViewCell {
    static let reuseId = "SubwayListTableviewCell"
    let circle = CircledDotView()

    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let metroName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black

        return label
    }()

    let numberOfATMs: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = #colorLiteral(red: 0.5999458432, green: 0.600034833, blue: 0.5999264717, alpha: 1)
        label.text = "21"

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        cardView.clipsToBounds = true

        overlayFirstLayer()
        overlaySecondLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func overlayFirstLayer() {
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

    private func overlaySecondLayer() {

        cardView.addSubview(circle)
        circle.setPosition(top: nil,
                           left: cardView.leftAnchor,
                           bottom: nil,
                           right: nil,
                           paddingTop: 0,
                           paddingLeft: 16,
                           paddingBottom: 0,
                           paddingRight: 0,
                           width: 12,
                           height: 12)

        circle.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        circle.mainColor = .brown

        cardView.addSubview(metroName)
        metroName.setPosition(top: nil,
                              left: circle.rightAnchor,
                              bottom: nil,
                              right: nil,
                              paddingTop: 0,
                              paddingLeft: 8,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
        metroName.centerYAnchor.constraint(equalTo: circle.centerYAnchor).isActive = true

        cardView.addSubview(numberOfATMs)
        numberOfATMs.setPosition(top: nil,
                                 left: nil,
                                 bottom: nil,
                                 right: cardView.rightAnchor,
                                 paddingTop: 0,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 16,
                                 width: 0,
                                 height: 0)
        numberOfATMs.centerYAnchor.constraint(equalTo: circle.centerYAnchor).isActive = true

    }

}
