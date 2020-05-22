//
//  ToggleButton.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class ToggleButton: UITextField {

    let rightButton  = UIButton(type: .custom)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()

    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setButton()

    }

    func setButton() {
        addSubview(rightButton)
        rightButton.setPosition(top: nil,
                                left: nil,
                                bottom: nil,
                                right: rightAnchor,
                                paddingTop: 0,
                                paddingLeft: 0,
                                paddingBottom: 0,
                                paddingRight: 0,
                                width: 24,
                                height: 24)
        rightButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    }

    func commonInit() {

        let image = UIImage(named: "password_show")?.withRenderingMode(.alwaysTemplate)
        rightButton.setImage(image, for: .normal)
        rightButton.tintColor = UIColor(white: 153.0 / 255.0, alpha: 1.0)
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)

        rightViewMode = .always
        rightView = rightButton
        isSecureTextEntry = true
    }

    @objc
    func toggleShowHide(button: UIButton) {
        toggle()
    }

    func toggle() {
        isSecureTextEntry = !isSecureTextEntry
        if isSecureTextEntry {
            let image = UIImage(named: "password_show")?.withRenderingMode(.alwaysTemplate)
            rightButton.setImage(image, for: .normal)
            rightButton.tintColor = UIColor(white: 153.0 / 255.0, alpha: 1.0)
        } else {
            let image = UIImage(named: "password_hide")?.withRenderingMode(.alwaysTemplate)
            rightButton.setImage(image, for: .normal)
            rightButton.tintColor = UIColor(white: 153.0 / 255.0, alpha: 1.0)
        }
    }

}
