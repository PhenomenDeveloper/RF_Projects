//
//  HeaderAddressMainVC.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class HeaderAddressCell: UICollectionViewCell {

    static let reuseId = "HeaderAddressCell"

   /// фоновое изображение ячейки адресов
    let backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .clear
        image.image = #imageLiteral(resourceName: "picMap")
        return image
    }()

    /// Заголовок ячейки
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .white
        return label
    }()
    /// Описание ячейки
    let subscriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
//        gradienLayer.frame = bounds
    }

    // MARK: - Расположение UI компонентов

    private func configureViewComponents() {

        self.addSubview(backgroundImageView)
        backgroundImageView.setPosition(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        backgroundImageView.addSubview(titleLabel)
        titleLabel.setPosition(top: backgroundImageView.topAnchor,
                               left: backgroundImageView.leftAnchor,
                               bottom: nil,
                               right: backgroundImageView.rightAnchor,
                               paddingTop: 12,
                               paddingLeft: 12,
                               paddingBottom: 0,
                               paddingRight: 0,
                               width: 0,
                               height: 20)

        backgroundImageView.addSubview(subscriptionLabel)
        subscriptionLabel.setPosition(top: titleLabel.bottomAnchor,
                                      left: backgroundImageView.leftAnchor,
                                      bottom: nil,
                                      right: backgroundImageView.rightAnchor,
                               paddingTop: 6,
                               paddingLeft: 12,
                               paddingBottom: 14,
                               paddingRight: 12,
                               width: 0,
                               height: 0)
    }
}
