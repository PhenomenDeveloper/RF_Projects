//
//  CustomNumButton.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIControl {

    // MARK: - Свойства

    var borderWidth: CGFloat = 1.0
    var borderColor = UIColor.gray.cgColor

    @IBInspectable var titleText: String? {
        didSet {
            self.titleTextLabel.text = titleText
        }
    }

    @IBInspectable var subTitleText: String? {
        didSet {
            self.subTitleTextLabel.text = subTitleText
        }
    }

    let titleTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    let subTitleTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: self.isHighlighted ? 0 : 0.25, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.alpha = self.isHighlighted ? 0.3 : 1
            })
        }
    }

    // MARK: - Инициализаторы

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Настройка внешнего вида для контрола

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2.0
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        setTitles()
    }

    func setTitles() {
        addSubview(titleTextLabel)
        if titleText == "0" {
            titleTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            titleTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        } else {
            titleTextLabel.setPosition(top: self.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 13, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            titleTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

            addSubview(subTitleTextLabel)
            subTitleTextLabel.setPosition(top: nil, left: nil, bottom: self.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 18, paddingRight: 0, width: 0, height: 0)
            subTitleTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
    }
}
