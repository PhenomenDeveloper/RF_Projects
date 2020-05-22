//
//  AtmPinIndicator.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 11.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class AtmPinIndicator: UIView {

    let backgroundImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "atmPinIndicator"))

        return imageView
    }()

    let atmTypeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    let shadowView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .black
        view.alpha = 0.2
        return view
    }()

    // MARK: - Инициализация
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 55, height: 50))

        UIView.animate(withDuration: 0.5) {
            self.scaleAnimation(fromValue: 0, toValue: 1)
        }
        configureView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }

    private func configureView() {

        addSubview(shadowView)
        shadowView.setPosition(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 7, paddingBottom: 0, paddingRight: 7, width: 0, height: 3)

        addSubview(backgroundImage)
        backgroundImage.fillToSuperView(view: self)

        addSubview(atmTypeImage)
        atmTypeImage.setPosition(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 7, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
    }

    func setImageForAtmType(typeID: Int) {
        switch typeID {
        case 1:
            atmTypeImage.image = UIImage(named: "icDepartment")
        case 3:
            atmTypeImage.image = UIImage(named: "icAtm")
        case 102:
            atmTypeImage.image = UIImage(named: "icTerminal")
        default:
            break
        }
    }

    ///Анимация появления и схлопования индикатора количество сообщений
    ///
    /// - Parameters:
    ///     - fromValue: С какого значения нужно анимировать
    ///     - toValue: До какого занчения нужно анимировать
    private func scaleAnimation(fromValue: CGFloat, toValue: CGFloat) {
        let animation = CABasicAnimation(keyPath: "transform.scale")

        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        self.layer.add(animation, forKey: "scale")
    }
}
