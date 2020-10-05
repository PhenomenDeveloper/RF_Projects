//
//  RegistrationMenu.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

protocol RangeTextfieldProtocol {
    func setNumberRange (textField: UITextField, range: Int, replacementString string: String) -> Bool
}

class RegistrationMenu: UIViewController {

    let bound: UIView = UIView()
    let secondBound: UIView = UIView()
    let thirdBound: UIView = UIView()
    let fourthBound: UIView = UIView()
    let fifthBound: UIView = UIView()
    var bottomConstraint: NSLayoutConstraint! = nil
    var contentSizeView: UIView = UIView()

    var constraintContentHeight: NSLayoutConstraint!

    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!

    let topText: UILabel = {
        let text = UILabel()
        text.text = "Регистрация"
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.registrationTopText, weight: .semibold)

        return text
    }()

    let loginTextField: UITextField = {
        let login = UITextField()
        let attributePlaceHolder = NSAttributedString(string: "Логин от интернет-банка", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 153.0 / 255.0, alpha: 1.0)])
        login.attributedPlaceholder = attributePlaceHolder
        login.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.registrationButtonLetters, weight: .regular)
        login.textColor = ThemeManager.Color.subtitleColor
        login.backgroundColor = .clear
        login.autocorrectionType = .no
        login.keyboardType = .emailAddress
        return login
    }()

    let passwordTextField: ToggleButton = {
        let password = ToggleButton()
        let attributePlaceHolder = NSAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.Color.subtitleColor])
        password.attributedPlaceholder = attributePlaceHolder
        password.textColor = ThemeManager.Color.subtitleColor
        password.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.registrationButtonLetters, weight: .regular)
        password.backgroundColor = .clear
        password.autocorrectionType = .no
        password.keyboardType = .emailAddress
        password.textContentType = .password
        return password
    }()

    let pinCodeField: ToggleButton = {
        let pinCode = ToggleButton()
        let attributePlaceHolder = NSAttributedString(string: "ПИН", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 153.0 / 255.0, alpha: 1.0)])
        pinCode.attributedPlaceholder = attributePlaceHolder
        pinCode.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.registrationButtonLetters, weight: .regular)
        pinCode.textColor = ThemeManager.Color.subtitleColor
        pinCode.backgroundColor = .clear
        pinCode.autocorrectionType = .no
        pinCode.keyboardType = .numberPad
        return pinCode
    }()

    let emailTextField: UITextField = {
        let email = UITextField()
        let attributePlaceHolder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 153.0 / 255.0, alpha: 1.0)])
        email.attributedPlaceholder = attributePlaceHolder
        email.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.registrationButtonLetters, weight: .regular)
        email.textColor = ThemeManager.Color.subtitleColor
        email.backgroundColor = .clear
        email.autocorrectionType = .no
        email.keyboardType = .emailAddress
        email.autocapitalizationType = .none
        return email
    }()

    let phoneTextField: UITextField = {
        let phone = UITextField()
        let attributePlaceHolder = NSAttributedString(string: "Номер телефона", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 153.0 / 255.0, alpha: 1.0)])
        phone.attributedPlaceholder = attributePlaceHolder
        phone.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.registrationButtonLetters, weight: .regular)
        phone.textColor = ThemeManager.Color.subtitleColor
        phone.backgroundColor = .clear
        phone.autocorrectionType = .no
        phone.keyboardType = .numberPad
        return phone
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.alwaysBounceHorizontal = false
        return scrollView
    }()

    lazy var registerButton: UIButton = {
        let regButton = UIButton(type: .system)
        regButton.setTitleColor(ThemeManager.Color.subtitleColor, for: .normal)
        regButton.setTitle("Регистрация", for: .normal)
        regButton.backgroundColor = ThemeManager.Color.backgroundColor
        regButton.titleLabel?.font = UIFont.systemFont(ofSize: ThemeManager.Font.Size.registrationButtonLetters, weight: .semibold)
        regButton.layer.cornerRadius = 8
        regButton.clipsToBounds = true
        regButton.isUserInteractionEnabled = false
        regButton.isEnabled = false
        regButton.addTarget(self, action: #selector(registerButtonTaped), for: .touchUpInside)
        return regButton
    }()

    ///Нажатие кнопки регистрации
    @objc func registerButtonTaped() {

        signIn()

        UserData.save(emailTextField.text!, name: loginTextField.text!, telephone: phoneTextField.text!)
        let login = LoginVC()
        login.modalPresentationStyle = .fullScreen
        self.present(login, animated: true, completion: nil)
    }

    // MARK: - SignIn

    func signIn() {
        view.endEditing(true)
        guard let login = loginTextField.text, login.count > 0 else { return }

        guard let password = passwordTextField.text, password.count > 0 else { return }

        guard let pin = pinCodeField.text, pin.count > 0 else { return }

        guard let email = emailTextField.text, email.count > 0 else { return }

        guard let phone = phoneTextField.text, phone.count > 0 else { return }

        Keychain.setPassword(pin, service: Keychain.service, account: Keychain.pinAccount)
        _ = Keychain.password(service: Keychain.service, account: Keychain.pinAccount)

        Keychain.setPassword(password, service: Keychain.service, account: Keychain.passwordAccount)
        _ = Keychain.password(service: Keychain.service, account: Keychain.passwordAccount)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientBackground()
        setupTopText()
        setupRegButton()
        setupScrollView()

        setupTextFieldComponents()
        setupBound()
        setupSecondBound()
        setupThirdBound()
        setupFourthBound()
        setupFifthBound()
        setupConstraints()
        phoneFormatter()
        mailValidation()

        loginTextField.delegate = self
        passwordTextField.delegate = self
        pinCodeField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self

        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupScrollView() {
         self.view.addSubview(scrollView)
        scrollView.setPosition(top: topText.bottomAnchor, left: view.leftAnchor, bottom: registerButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        scrollView.addSubview(contentSizeView)

        contentSizeView.fillToSuperView(view: scrollView)
        contentSizeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

       constraintContentHeight = contentSizeView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        constraintContentHeight.isActive = true
    }

    private func setupBound() {
        bound.backgroundColor = ThemeManager.Color.separatorColor
        self.contentSizeView.addSubview(bound)
    }

    private func setupSecondBound() {
        secondBound.backgroundColor = ThemeManager.Color.separatorColor
        self.contentSizeView.addSubview(secondBound)
    }

    private func setupThirdBound() {
        thirdBound.backgroundColor = ThemeManager.Color.separatorColor
        self.contentSizeView.addSubview(thirdBound)
    }

    private func setupFourthBound() {
        fourthBound.backgroundColor = ThemeManager.Color.separatorColor
        self.contentSizeView.addSubview(fourthBound)
    }

    private func setupFifthBound() {
        fifthBound.backgroundColor = ThemeManager.Color.separatorColor
        self.contentSizeView.addSubview(fifthBound)
    }

    private func setupGradientBackground() {
        let gradientView = BackgroundGradient(frame: view.frame)
        gradientView.startColor = ThemeManager.Color.startGradientColor
        gradientView.endColor = ThemeManager.Color.endGradientColor

        self.view.addSubview(gradientView)
    }

    func isValidateEmail(email: String?) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    func mailValidation() {
        emailTextField.addTarget(self, action: #selector(self.mailFieldDidChanged), for: UIControl.Event.editingDidEnd)
    }
    @objc func mailFieldDidChanged() {

        let mailValid = isValidateEmail(email: emailTextField.text!)
        if mailValid == false {

            UIView.animate(withDuration: 0.15, delay: 0, options: [.repeat, .autoreverse], animations: {
                self.registerButton.isEnabled = false
                self.thirdBound.backgroundColor = #colorLiteral(red: 0.8859351277, green: 0.08215577155, blue: 0.08173171431, alpha: 1)

            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.thirdBound.layer.removeAllAnimations()
                self.thirdBound.backgroundColor = ThemeManager.Color.separatorColor
            }
        } else {
            registerButton.isEnabled = true
        }
    }

    ///Форматирование номера телефона
    func phoneFormatter() {

        phoneTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let phoneNumber = phoneTextField.text?.toPhoneNumber()
        if phoneTextField.text?.count == 11 {
            phoneTextField.text = phoneNumber
        }
    }

    fileprivate func setupTextFieldComponents() {
        setupLoginField()
        setupPasswordField()
        setupPinCodeField()
        setupEmailField()
        setupPhoneField()
    }

    private func setupConstraints() {
        bound.setPosition(top: loginTextField.bottomAnchor, left: contentSizeView.leftAnchor, bottom: nil, right: contentSizeView.rightAnchor, paddingTop: 14, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
        secondBound.setPosition(top: passwordTextField.bottomAnchor, left: contentSizeView.leftAnchor, bottom: nil, right: contentSizeView.rightAnchor, paddingTop: 14, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
        thirdBound.setPosition(top: emailTextField.bottomAnchor, left: contentSizeView.leftAnchor, bottom: nil, right: contentSizeView.rightAnchor, paddingTop: 14, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
        fourthBound.setPosition(top: phoneTextField.bottomAnchor, left: contentSizeView.leftAnchor, bottom: nil, right: contentSizeView.rightAnchor, paddingTop: 14, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
        fifthBound.setPosition(top: pinCodeField.bottomAnchor, left: contentSizeView.leftAnchor, bottom: nil, right: contentSizeView.rightAnchor, paddingTop: 14, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
    }

    fileprivate func setupTopText() {
        view.addSubview(topText)

        topText.setPosition(top: view.safeAreaLayoutGuide.topAnchor,
                            left: nil,
                            bottom: nil,
                            right: nil,
                            paddingTop: 45,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 0,
                            width: 0,
                            height: 20)
        topText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    fileprivate func setupLoginField() {
        contentSizeView.addSubview(loginTextField)

        loginTextField.setPosition(top: contentSizeView.topAnchor,
                                   left: contentSizeView.leftAnchor,
                                   bottom: nil,
                                   right: contentSizeView.rightAnchor,
                                   paddingTop: 56,
                                   paddingLeft: 24,
                                   paddingBottom: 0,
                                   paddingRight: 24,
                                   width: 0,
                                   height: 30)

    }

    fileprivate func setupPasswordField() {
        passwordTextField.backgroundColor = .clear
        contentSizeView.addSubview(passwordTextField)

        passwordTextField.setPosition(top: loginTextField.bottomAnchor,
                                      left: contentSizeView.leftAnchor,
                                      bottom: nil,
                                      right: contentSizeView.rightAnchor,
                                      paddingTop: 44,
                                      paddingLeft: 24,
                                      paddingBottom: 0,
                                      paddingRight: 24,
                                      width: 0,
                                      height: 0)
    }

    fileprivate func setupPinCodeField() {
        passwordTextField.backgroundColor = .clear
        contentSizeView.addSubview(pinCodeField)

        pinCodeField.setPosition(top: passwordTextField.bottomAnchor,
                                 left: contentSizeView.leftAnchor,
                                 bottom: nil,
                                 right: contentSizeView.rightAnchor,
                                 paddingTop: 44,
                                 paddingLeft: 24,
                                 paddingBottom: 0,
                                 paddingRight: 24,
                                 width: 0,
                                 height: 30)
    }

    fileprivate func setupEmailField() {
        passwordTextField.backgroundColor = .clear
        contentSizeView.addSubview(emailTextField)

        emailTextField.setPosition(top: pinCodeField.bottomAnchor,
                                   left: contentSizeView.leftAnchor,
                                   bottom: nil,
                                   right: contentSizeView.rightAnchor,
                                   paddingTop: 44,
                                   paddingLeft: 24,
                                   paddingBottom: 0,
                                   paddingRight: 24,
                                   width: 0,
                                   height: 30)
    }

    fileprivate func setupPhoneField() {
        passwordTextField.backgroundColor = .clear
        contentSizeView.addSubview(phoneTextField)

        phoneTextField.setPosition(top: emailTextField.bottomAnchor,
                                   left: contentSizeView.leftAnchor,
                                   bottom: nil,
                                   right: contentSizeView.rightAnchor,
                                   paddingTop: 44,
                                   paddingLeft: 24,
                                   paddingBottom: 0,
                                   paddingRight: 24,
                                   width: 0,
                                   height: 30)
    }

    fileprivate func setupRegButton() {
        view.addSubview(registerButton)

        registerButton.setPosition(top: nil,
                                   left: view.leftAnchor,
                                   bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   right: view.rightAnchor,
                                   paddingTop: 0,
                                   paddingLeft: 24,
                                   paddingBottom: 20,
                                   paddingRight: 24,
                                   width: 0,
                                   height: 56)

        bottomConstraint = registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        bottomConstraint.isActive = true
    }

    func checkFields() {

        if let text = loginTextField.text, text.isEmpty {
            disableButton()
            return
        }
        if let text = passwordTextField.text {
            if text.isEmpty || (text.count < 6 && text.count <= 18) {
                disableButton()
                return
            }
        }
        if let text = pinCodeField.text {
            if text.isEmpty || text.count < 4 {
                disableButton()
                return
            }
        }

        if let text = emailTextField.text {
            if text.isEmpty || !isValidateEmail(email: text) {
                disableButton()
                return
            }
        }
        if let text = phoneTextField.text, text.count != 18 {
            disableButton()
            return
        } else {
            enableButton()
            return
        }

    }

    func enableButton() {
        registerButton.isUserInteractionEnabled = true
        registerButton.isEnabled = true

        if self.registerButton.backgroundColor == ThemeManager.Color.backgroundColor {
            UIView.animate(withDuration: 1) {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.8392156863, blue: 0.03921568627, alpha: 1)
                self.registerButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            }
        }
    }

    func disableButton() {
        registerButton.isUserInteractionEnabled = false
        registerButton.isEnabled = false

        if self.registerButton.backgroundColor == #colorLiteral(red: 0.9960784314, green: 0.8392156863, blue: 0.03921568627, alpha: 1) {
            UIView.animate(withDuration: 1) {
                self.registerButton.backgroundColor = ThemeManager.Color.backgroundColor
                self.registerButton.setTitleColor(ThemeManager.Color.subtitleColor, for: .normal)
            }
        }
    }

}

extension RegistrationMenu: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFields()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == pinCodeField {
            return setNumberRange(textField: textField, range: 4, replacementString: string)
        } else if textField == phoneTextField {
            return setNumberRange(textField: textField, range: 18, replacementString: string)
        } else if textField == passwordTextField {
            return setNumberRange(textField: textField, range: 18, replacementString: string)
        }
        return true
    }
}

extension RegistrationMenu: RangeTextfieldProtocol {
    func setNumberRange (textField: UITextField, range: Int, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count
        return newLength <= range
    }
}

// MARK: Keyboard Handling
extension RegistrationMenu {
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height

            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight.constant += self.keyboardHeight
            })

            // move if keyboard hide input field
            let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom

            if collapseSpace < 0 {
                // no collapse
                return
            }

            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10 - self.registerButton.frame.height)
            })
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            guard let height = self.keyboardHeight else { return }
            self.constraintContentHeight.constant -= height

            self.scrollView.contentOffset = self.lastOffset
        }

        keyboardHeight = nil
    }
}
