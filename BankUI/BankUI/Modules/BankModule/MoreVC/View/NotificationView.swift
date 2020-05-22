//
//  NotificationView.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 05.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    // MARK: - Свойства

    lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(#imageLiteral(resourceName: "bell"), for: .normal)

        return button
    }()

    let notificationLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
