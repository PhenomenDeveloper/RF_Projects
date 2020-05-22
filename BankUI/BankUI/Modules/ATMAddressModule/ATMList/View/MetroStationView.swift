//
//  MetroStationView.swift
//  BankUI
//
//  Created by Lev Kolesnikov on 20.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class MetroStationView: UIView {

    var stationCircleView: CircledDotView = CircledDotView()

    var stationNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.accessibilityIdentifier = "SubwayStationName"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        setupConstraints()
    }

    private func setupConstraints() {
        self.addSubview(stationCircleView)

        stationCircleView.setPosition(top: nil,
                                      left: leftAnchor,
                                      bottom: nil,
                                      right: nil,
                                      paddingTop: 0,
                                      paddingLeft: 0,
                                      paddingBottom: 0,
                                      paddingRight: 0,
                                      width: 12,
                                      height: 12)
        stationCircleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        self.addSubview(stationNameLabel)

        stationNameLabel.setPosition(top: topAnchor,
                                left: stationCircleView.rightAnchor,
                                bottom: bottomAnchor,
                                right: rightAnchor,
                                paddingTop: 0,
                                paddingLeft: 8,
                                paddingBottom: 0,
                                paddingRight: 16,
                                width: 0,
                                height: 0)

        stationNameLabel.centerYAnchor.constraint(equalTo: stationCircleView.centerYAnchor).isActive = true
    }

}
