//
//  NotificationBell.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 06.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

protocol CheckNotificationsProtocol: class {
    ///Что надо сделать, когда пользователь проверяет уведомления
    func checkNotification()
}

class NotificationBell: UIView {

    // MARK: - Свойства

    weak var delegate: CheckNotificationsProtocol?

    private lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(#imageLiteral(resourceName: "alarm"), for: .normal)
        button.addTarget(self, action: #selector(handleNotificationsTapped), for: .touchUpInside)
        return button
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

        self.backgroundColor = .clear
        self.clipsToBounds = true

        addSubview(notificationButton)
        notificationButton.setPosition(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
    }

    ///Установка кнопки в состояние - непрочитанных уведомлений
    func setNotification() {
        UIView.animate(withDuration: 0.5) {
            self.backgroundColor = UIColor.init(red: 255/255, green: 217/255, blue: 0, alpha: 1)
            self.notificationButton.tintColor = .black
        }
    }

    ///Установка кнопки в состояние - нет уведомлений
    private func checkNotification() {
        UIView.animate(withDuration: 0.5) {
            self.backgroundColor = .clear
            self.notificationButton.tintColor = .white
        }
    }

    @objc private func handleNotificationsTapped() {
        checkNotification()
        delegate?.checkNotification()
    }
}
