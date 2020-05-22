//
//  ATMFilterCell.swift
//  BankUI
//
//  Created by Lev Kolesnikov on 1/29/20.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class ATMFilterCell: UITableViewCell {

    static let reuseId = "ATMCellID"

    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let cellLine: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        return uiView
    }()

    let filterName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.accessibilityIdentifier = "FilterCellName"
        return label
    }()

    private lazy var birdBox: CheckBoxView = {
        let check = CheckBoxView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        check.addTarget(self, action: #selector(checkBox), for: .touchUpInside)
        check.accessibilityIdentifier = "FilterCellButton"
        return check
    }()

    @objc func checkBox() {
        birdBox.isSelected = !birdBox.isSelected
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()

    }

    private func setup() {
        addSubview(cellView)
        cellView.addSubview(filterName)
        cellView.addSubview(birdBox)
        cellView.addSubview(cellLine)

        cellView.setPosition(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        birdBox.setPosition(top: cellView.topAnchor, left: cellView.leftAnchor, bottom: cellView.bottomAnchor, right: nil, paddingTop: 14, paddingLeft: 16, paddingBottom: 14, paddingRight: 0, width: 0, height: 0)

        cellLine.setPosition(top: nil, left: cellView.leftAnchor, bottom: cellView.bottomAnchor, right: cellView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)

        filterName.setPosition(top: cellView.topAnchor, left: birdBox.rightAnchor, bottom: cellLine.topAnchor, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 0, width: 0, height: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getFlag() -> Bool {
        return birdBox.isSelected
    }

    func setDefaultFlag() {
        birdBox.isSelected = true
    }

    func setFilterFlag(value: Bool) {
        switch value {
        case true:
            birdBox.isSelected = value
        default:
            break
        }
    }
}
