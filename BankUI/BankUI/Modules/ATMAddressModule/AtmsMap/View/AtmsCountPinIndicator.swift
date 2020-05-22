//
//  AtmsCountPinIndicator.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 11.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class AtmsCountPinIndicator: UIView {

    let atmsCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "5"
        label.textColor = UIColor.init(red: 255/255, green: 219/255, blue: 0, alpha: 1)
        label.contentMode = .center
        return label
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        UIView.animate(withDuration: 0.5) {
            self.scaleAnimation(fromValue: 0, toValue: 1)
        }
        configureView()
    }

    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }

    private func configureView() {

        self.backgroundColor = .black
        self.clipsToBounds = true
        self.layer.cornerRadius = self.layer.bounds.height / 2

        addSubview(atmsCount)
        atmsCount.translatesAutoresizingMaskIntoConstraints = false
        atmsCount.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        atmsCount.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    func setAtmsCount(count: Int) {
//        self.frame = CGRect(x: 0, y: 0, width: 46, height: 30)
        atmsCount.text = String(count)
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
