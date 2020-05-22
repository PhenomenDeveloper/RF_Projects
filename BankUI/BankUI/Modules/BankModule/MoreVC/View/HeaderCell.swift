//
//  HeaderCell.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {

    ///Фоновый градиент
    private let gradientLayer = CAGradientLayer()

    ///Лого банка
    let logoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = .clear
        image.image = UIImage(named: "logo")
        return image
    }()

    ///Текст ячейки
    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
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
        logoImageView.setPosition(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 41, height: 66)
        logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.addSubview(textLabel)
        textLabel.setPosition(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: logoImageView.leftAnchor, paddingTop: 30, paddingLeft: 12, paddingBottom: 12, paddingRight: 8, width: 0, height: 0)
    }

    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 0)
    }

    func setupGradientsColor(startColor: UIColor, endColor: UIColor) {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
