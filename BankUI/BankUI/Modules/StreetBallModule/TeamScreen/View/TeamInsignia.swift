//
//  TeamInsignia.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation

import UIKit

class TeamInsignia: UIView {

    let teamNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Бизоны"
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .black
        return label
    }()

    let teamLogo: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.backgroundColor = .clear
        image.image = UIImage(named: "bizons")
        return image
    }()

    // MARK: - Инициализация

    override init(frame: CGRect) {
        super.init(frame: frame)
         configureViewComponents()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
         configureViewComponents()
    }

    private func configureViewComponents() {

        teamLogo.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        teamLogo.layer.borderWidth = 2.0
        teamLogo.layer.cornerRadius = 10.0

        self.addSubview(teamNameLabel)
        teamNameLabel.setPosition(top: topAnchor,
                                  left: nil,
                                  bottom: nil,
                                  right: nil,
                                  paddingTop: 10,
                                  paddingLeft: 0,
                                  paddingBottom: 0,
                                  paddingRight: 0,
                                  width: 0,
                                  height: 0)

        self.addSubview(teamLogo)

        teamLogo.setPosition(top: teamNameLabel.bottomAnchor,
                             left: nil,
                             bottom: bottomAnchor,
                             right: nil,
                             paddingTop: 20,
                             paddingLeft: 0,
                             paddingBottom: 20,
                             paddingRight: 0,
                             width: 200,
                             height: 200)
        teamLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        teamNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

}
