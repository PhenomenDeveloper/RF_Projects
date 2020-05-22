//
//  NotificationLabel.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 06.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class NotificationLabel: UIView {

    let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.tintColor = .black
        return label
    }()

    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.layer.bounds.height / 2
    }

    private func configureView() {

        self.backgroundColor = .white
        self.clipsToBounds = true

        addSubview(notificationLabel)
        notificationLabel.setPosition(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
    }

    ///Устанавливает количество уведомлений
    /// - Parameters:
    ///     - count: Количество уведомлений
    func setNotification(with count: Int) {

        if count == 1 {
            UIView.animate(withDuration: 0.5) {
                self.scaleAnimation(fromValue: 0.0, toValue: 1.0)
                self.shakeAnimation()
                self.notificationLabel.text = String(count)
                self.layoutSubviews()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.shakeAnimation()
                self.notificationLabel.text = String(count)
                self.layoutSubviews()
            }
        }

    }

    ///Аннимация потряхивания, при получении нового уведомления
    private func shakeAnimation() {

        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-2.5, 2.5, -2.5, 2.5, -1.5, 1.5, -1.5, 1.5, 0.0 ]
        self.layer.add(animation, forKey: "shake")
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
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        self.layer.add(animation, forKey: "scale")
    }

    ///Что надо сделать, когда пользователь проверяет уведомления
    func checkNotifications() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.notificationLabel.text = ""
        }
        self.scaleAnimation(fromValue: 1.0, toValue: 0.0)
        CATransaction.commit()
    }
}
