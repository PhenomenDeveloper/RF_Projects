//
//  CustomNotificationVC.swift
//  BankUI
//
//  Created by MANVELYAN Gevorg on 11.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class CustomNotificationView: UIView {

    // MARK: - UI элементы

    ///view для округления углов
    let containerView: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 15
        container.clipsToBounds = true
        return container
    }()

    ///label с текстом уведомления
    private var notificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "Отсутствует подключение к сети Интернет"
        return label
    }()

    ///крестик для закрытия уведомления
    private let crossImageView: UIImageView = {
        let cross: UIImageView = UIImageView()
        cross.image = #imageLiteral(resourceName: "cross")
        cross.contentMode = .scaleAspectFit

        return cross
    }()

    // MARK: - Вспомогательные функции

    func addShadow() {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 1.0)
    //        layer.shadowOffset = .zero
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 3.0
        }

    ///Выполнить анимацию уведомления
    func startNotification() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        self.scaleAnimation(fromValue: 0, toValue: 1)
        }
    }

    ///добавляет view с крестиков действие по нажатию
    func configureCrossView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeNotification))
        crossImageView.isUserInteractionEnabled = true
        crossImageView.addGestureRecognizer(tap)
    }

    // MARK: - Обработка нажатий

    @objc func closeNotification() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.scaleAnimation(fromValue: 1, toValue: 0)
        }, completion: nil)
    }

    // MARK: - Инициализация

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupNotificationLabel()
        setupCrossImageView()
        configureCrossView()
        self.addShadow()
        startNotification()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        self.backgroundColor = nil
    }

    ///Анимация появления и схлопования
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

    // MARK: - Расстановка UI компонентов

    func setupContainerView() {
        self.addSubview(containerView)
        containerView.fillToSuperView(view: self)
    }

    func setupNotificationLabel() {
        containerView.addSubview(notificationLabel)
        notificationLabel.setPosition(top: self.topAnchor,
                                      left: self.leftAnchor,
                                      bottom: self.bottomAnchor,
                                      right: nil,
                                      paddingTop: 5,
                                      paddingLeft: 15,
                                      paddingBottom: 5,
                                      paddingRight: 3,
                                      width: 0,
                                      height: 0)
    }

    func setupCrossImageView() {
        containerView.addSubview(crossImageView)
        crossImageView.setPosition(top: nil,
                                   left: nil,
                                   bottom: nil,
                                   right: self.rightAnchor,
                                   paddingTop: 0,
                                   paddingLeft: 0,
                                   paddingBottom: 0,
                                   paddingRight: 15,
                                   width: 12,
                                   height: 12)
        crossImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
