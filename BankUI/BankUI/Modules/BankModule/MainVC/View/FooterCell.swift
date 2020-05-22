//
//  FooterCell.swift
//  BankUI
//
//  Created by MANVELYAN Gevorg on 14.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class FooterCell: UICollectionViewCell {

    ///Фоновый градиент
    private let gradientLayer = CAGradientLayer()

    let logoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = .clear
        image.image = #imageLiteral(resourceName: "group22Copy2")
        return image
    }()

    ///Текст ячейки
    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()

    // MARK: - Инициализаторы

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        configureViewComponents()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //        растягиваем по всем границами
        gradientLayer.frame = bounds
    }

    // MARK: - Расположение UI компонентов

    private func configureViewComponents() {
        setupGradient()

        self.addSubview(logoImageView)
        logoImageView.setPosition(top: topAnchor,
                                  left: leftAnchor,
                                  bottom: nil,
                                  right: rightAnchor,
                                  paddingTop: 8,
                                  paddingLeft: 8,
                                  paddingBottom: 0,
                                  paddingRight: 102,
                                  width: 48,
                                  height: 48)

        self.addSubview(textLabel)
        textLabel.setPosition(top: logoImageView.bottomAnchor,
                              left: logoImageView.leftAnchor,
                              bottom: nil,
                              right: rightAnchor,
                              paddingTop: 12,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 8,
                              width: 0,
                              height: 0)
        textLabel.contentMode = .bottomRight
    }

    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }

    func setupGradientsColor(startColor: UIColor, endColor: UIColor) {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
