//
//  NotificationView.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 06.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    private let notificationButton = NotificationBell()
    private let notificationLabel = NotificationLabel()
    weak var delegate: CheckNotificationsProtocol?

    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        notificationButton.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func configureView() {

        self.backgroundColor = .clear
        addSubview(notificationButton)
        notificationButton.fillToSuperView(view: self)

        addSubview(notificationLabel)
        notificationLabel.setPosition(top: nil, left: leftAnchor, bottom: topAnchor, right: nil, paddingTop: 0, paddingLeft: 22, paddingBottom: -10, paddingRight: 0, width: 0, height: 0)
    }

    ///Устанавливает количество уведомлений
    /// - Parameters:
    ///     - count: Количество уведомлений
    func setLabel(with count: Int) {
        if count == 1 {
            notificationButton.setNotification()
        }
        notificationLabel.setNotification(with: count)
    }
}

extension NotificationView: CheckNotificationsProtocol {

    ///Что надо сделать, когда пользователь проверяет уведомления
    func checkNotification() {
        notificationLabel.checkNotifications()
        delegate?.checkNotification()
    }
}
