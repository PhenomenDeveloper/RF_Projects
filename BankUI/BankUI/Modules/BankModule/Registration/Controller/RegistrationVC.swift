//
//  RegistrationVC.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {

    let bound: UIView = UIView()
    let secondBound: UIView = UIView()

    let topText: UILabel = {
        let text = UILabel()
            text.text = "Вход или регистрация"
            text.textColor = .white
            text.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        return text
    }()

    let loginTextField: UITextField = {
        let login = UITextField()
        let attributePlaceHolder = NSAttributedString(string: "Логин от интернет-банка", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 153.0 / 255.0, alpha: 1.0)])
            login.attributedPlaceholder = attributePlaceHolder
            login.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            login.textColor = UIColor(white: 153.0 / 255.0, alpha: 1.0)
            login.backgroundColor = .clear
        return login
    }()

    let passwordTextField: ToggleButton = {
        let password = ToggleButton()
        let attributePlaceHolder = NSAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 153.0 / 255.0, alpha: 1.0)])
            password.attributedPlaceholder = attributePlaceHolder
            password.textColor = UIColor(white: 153.0 / 255.0, alpha: 1.0)
            password.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            password.backgroundColor = .clear
        return password
    }()

    let loginButton: UIButton = {
        let logButton = UIButton(type: .system)
            logButton.setTitleColor(UIColor(white: 153.0 / 255.0, alpha: 1.0), for: .normal)
            logButton.setTitle("Войти", for: .normal)
            logButton.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            logButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            logButton.layer.cornerRadius = 8
            logButton.clipsToBounds = true
        return logButton
    }()

    let forgotButton: UIButton = {
        let forgotBut = UIButton(type: .system)
            forgotBut.setTitleColor(UIColor(white: 255.0 / 255.0, alpha: 1.0), for: .normal)
            forgotBut.setTitle("Забыли пароль?", for: .normal)
            forgotBut.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            forgotBut.backgroundColor = .clear
        return forgotBut
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupTopText()
        setupTextFieldComponents()
        setupBound()
        setupSecondBound()
        setupConstraints()
        setupLoginButton()
        setupForgotButton()
    }

    private func setupBound() {

        bound.backgroundColor = ThemeManager.Color.separatorColor
            self.view.addSubview(bound)
        }

    private func setupSecondBound() {
        secondBound.backgroundColor = ThemeManager.Color.separatorColor
        self.view.addSubview(secondBound)
    }

    private func setupGradientBackground() {
        let gradientView = BackgroundGradient(frame: view.frame)
        gradientView.startColor = ThemeManager.Color.startGradientColor
        gradientView.endColor = ThemeManager.Color.endGradientColor

        self.view.addSubview(gradientView)
    }

    fileprivate func setupTextFieldComponents() {
        setupLoginField()
        setupPasswordField()
    }

    private func setupConstraints() {
        bound.setPosition(top: loginTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 14, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
        secondBound.setPosition(top: passwordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 14, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
    }

    fileprivate func setupTopText() {
        view.addSubview(topText)

        topText.setPosition(top: view.safeAreaLayoutGuide.topAnchor,
                            left: nil,
                            bottom: nil,
                            right: nil,
                            paddingTop: 73,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 0,
                            width: 0,
                            height: 20)
        topText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    fileprivate func setupLoginField() {
        view.addSubview(loginTextField)

        loginTextField.setPosition(top: topText.bottomAnchor,
                                   left: view.leftAnchor,
                                   bottom: nil,
                                   right: view.rightAnchor,
                                   paddingTop: 96,
                                   paddingLeft: 24,
                                   paddingBottom: 0,
                                   paddingRight: 24,
                                   width: 0,
                                   height: 30)

    }

    fileprivate func setupPasswordField() {
        passwordTextField.backgroundColor = .clear
        view.addSubview(passwordTextField)

        passwordTextField.setPosition(top: loginTextField.bottomAnchor,
                                      left: loginTextField.leftAnchor,
                                      bottom: nil,
                                      right: loginTextField.rightAnchor,
                                      paddingTop: 64,
                                      paddingLeft: 0,
                                      paddingBottom: 0,
                                      paddingRight: 0,
                                      width: 0,
                                      height: 30)
    }

    fileprivate func setupLoginButton() {
        view.addSubview(loginButton)

        loginButton.setPosition(top: passwordTextField.bottomAnchor,
                                left: passwordTextField.leftAnchor,
                                bottom: nil,
                                right: passwordTextField.rightAnchor,
                                paddingTop: 74,
                                paddingLeft: 0,
                                paddingBottom: 0,
                                paddingRight: 0,
                                width: 0,
                                height: 56)
    }

    fileprivate func setupForgotButton() {
        view.addSubview(forgotButton)

        forgotButton.setPosition(top: loginButton.bottomAnchor,
                                 left: nil,
                                 bottom: nil,
                                 right: nil,
                                 paddingTop: 31,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 0,
                                 width: 0,
                                 height: 30)

        forgotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
