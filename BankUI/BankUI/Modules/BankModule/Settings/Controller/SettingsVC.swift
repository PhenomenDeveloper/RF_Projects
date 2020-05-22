//
//  SettingsVC.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    // MARK: - Объявление переменных
    private var direction: NavigationTitleAnimationDirection = .left

    var prevTitle: String?

    var containerView = UIView()

    private var signaturePath: [Line] = []
    ///Слой, который содержит в себе анимацию отрисовки подписи
    private var drawingLayer: CAShapeLayer = CAShapeLayer()
    ///Положение верхней границы карточки представления
    private var topCardViewConstraint: NSLayoutConstraint!

    let confirmButton: UIButton = UIButton(type: .system)
    let mailLabel: UILabel = UILabel()
    let mailField: UITextField = UITextField()
    let bound: UIView = UIView()
    let phoneLabel: UILabel = UILabel()
    let phoneField: UITextField = UITextField()
    let secondBound: UIView = UIView()
    let signatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 0.6352370977, green: 0.6353307366, blue: 0.6352165937, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        label.text = "Подпись"
        return label
    }()
    lazy var createSignatureButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.8635197282, green: 0.8586989641, blue: 0.8586453795, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitle("Создать подпись", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        button.addTarget(self, action: #selector(createSignature), for: .touchUpInside)
        return button
    }()

    var bottomConstraint: NSLayoutConstraint! = nil
    weak var delegate: GoToMainVC?

    let signatureVCPresenter = TransitionCardFromBottom(presentDuration: 0.6, dismissDuration: 0.3, interactionController: nil)

    lazy var signatureView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0.2309085436, green: 0.2398462948, blue: 0.2547333062, alpha: 1)
        view.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createSignature))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupContainerView(container: containerView, containerColor: ThemeManager.Color.backgroundColor)

        setupMailLabel()
        setupMailTextField()
        setupBound()
        setupPhoneLabel()
        setupPhoneTextField()
        setupSecondBound()
        setupButton()
        setupConstraints()
        phoneFormatter()
        mailValidation()

        phoneField.delegate = self

        // Наблюдение за клавиатурой
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let navController = navigationController else { return }
        addNavigationControllerTitleAnimation(navVC: navController, nextTitle: "Настройки", direction: direction)
    }

    deinit {
        //Stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    // MARK: - Настройка элементов view

    private func setupButton() {
        confirmButton.backgroundColor = #colorLiteral(red: 0.2309085436, green: 0.2398462948, blue: 0.2547333062, alpha: 1)
        confirmButton.setTitle("Подтвердить", for: .normal)
        confirmButton.layer.cornerRadius = 8
        confirmButton.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        self.view.addSubview(confirmButton)
    }

    private func setupMailLabel() {
        mailLabel.backgroundColor = .clear
        mailLabel.textColor = #colorLiteral(red: 0.6352370977, green: 0.6353307366, blue: 0.6352165937, alpha: 1)
        mailLabel.textAlignment = NSTextAlignment.center
        mailLabel.text = "E-Mail"
        self.view.addSubview(mailLabel)
    }

    private func setupMailTextField() {
        mailField.delegate = self
        mailField.backgroundColor = .clear
        mailField.text = UserData.getUserInfo().email
        self.view.addSubview(mailField)
        mailField.autocorrectionType = .no
    }

    private func setupBound() {
        bound.backgroundColor = #colorLiteral(red: 0.8822658658, green: 0.8824142814, blue: 0.8908544183, alpha: 1)
        self.view.addSubview(bound)
    }

    private func setupPhoneLabel() {
        phoneLabel.backgroundColor = .clear
        phoneLabel.textColor = #colorLiteral(red: 0.6352370977, green: 0.6353307366, blue: 0.6352165937, alpha: 1)
        phoneLabel.textAlignment = NSTextAlignment.center
        phoneLabel.text = "Номер телефона"
        self.view.addSubview(phoneLabel)
    }
    private func setupPhoneTextField() {
        phoneField.delegate = self
        phoneField.backgroundColor = .clear
        phoneField.text = UserData.getUserInfo().telephone
        self.view.addSubview(phoneField)
        phoneField.autocorrectionType = .no
        phoneField.keyboardType = .numberPad
    }
    private func setupSecondBound() {secondBound.backgroundColor = #colorLiteral(red: 0.8822658658, green: 0.8824142814, blue: 0.8908544183, alpha: 1)
        self.view.addSubview(secondBound)
    }

    // MARK: - Настройка Constraints
    private func setupConstraints() {
        mailLabel.setPosition(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        mailField.setPosition(top: mailLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 13, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        bound.setPosition(top: mailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
        phoneLabel.setPosition(top: bound.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        phoneField.setPosition(top: phoneLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 13, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
        secondBound.setPosition(top: phoneField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)

        view.addSubview(signatureLabel)
        signatureLabel.setPosition(top: secondBound.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        view.addSubview(createSignatureButton)
        createSignatureButton.setPosition(top: signatureLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 13, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 150, height: 40)

        confirmButton.setPosition(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)

        bottomConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        bottomConstraint.isActive = true

        view.addSubview(signatureView)
        signatureView.setPosition(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: view.layer.bounds.height / 3)

        view.layoutSubviews()
        topCardViewConstraint = signatureView.topAnchor.constraint(equalTo: signatureLabel.bottomAnchor, constant: view.layer.bounds.height - createSignatureButton.layer.position.y)
        topCardViewConstraint.isActive = true
    }

    // MARK: - События клавиатуры

    //    Перемещение кнопки вверх, при открытии клавиатуры
    @objc func keyboardWillChange(notification: Notification) {

        //        Определение размера клавиатуры
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            switch DeviceType.getCurrentPhoneOfUser() {
            case .iphone11, .iphone11Pro, .iphone11ProMax:
                bottomConstraint.constant = 49 - keyboardRect.height
            default:
                bottomConstraint.constant = -32 + 49 - keyboardRect.height
            }
            view.layoutIfNeeded()
        } else {
            bottomConstraint.constant = -32
            view.layoutIfNeeded()
        }
    }

    // MARK: - Нажатие кнопок

    @objc func confirmButtonAction(sender: UIButton!) {

        UserData.saveNewData(mailField.text!, telephone: phoneField.text!)
        delegate?.goToMainVC()
    }

    @objc func createSignature() {
        let signatureVC = SignatureVC()
        signatureVC.delegate = self
        signatureVC.transitioningDelegate = self
        signatureVC.modalPresentationStyle = .custom
        self.present(signatureVC, animated: true, completion: nil)
    }

    // MARK: - Валидация входных параметров

    ///Проверка валидности почты
    ///
    /// - Parameters:
    ///     -  email: проверяемая почта
    /// - Returns:
    ///     true - почта валидна, false - почта не валидна
    func isValidateEmail(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    ///Анимирование ошибки ввода почты

    func mailValidation() {
        mailField.addTarget(self, action: #selector(self.mailFieldDidChanged), for: UIControl.Event.editingDidEnd)
    }
    @objc func mailFieldDidChanged() {

        let mailValid = isValidateEmail(email: mailField.text!)
        if mailValid == false {

            UIView.animate(withDuration: 0.15, delay: 0, options: [.repeat, .autoreverse], animations: {

                self.bound.backgroundColor = #colorLiteral(red: 0.8859351277, green: 0.08215577155, blue: 0.08173171431, alpha: 1)
                self.confirmButton.isEnabled = false

            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.bound.layer.removeAllAnimations()
                self.bound.backgroundColor = #colorLiteral(red: 0.8822658658, green: 0.8824142814, blue: 0.8908544183, alpha: 1)
            }
        } else {
            confirmButton.isEnabled = true
        }
    }

    ///Форматирование номера телефона

    func phoneFormatter() {

        phoneField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let phoneNumber = phoneField.text?.toPhoneNumber()
        if phoneField.text?.count == 11 {
            phoneField.text = phoneNumber
        }
    }

    // MARK: - Получение подписи пользователя

    ///Очищает содержимое
    func clear() {
        //Удаляем слой анимации, чтобы очистить поверхность для рисования
        drawingLayer.removeFromSuperlayer()
        //Удаляем точки из массива, чтобы очистить поле для отрисовки анимации
        signaturePath.removeAll()
        view.setNeedsDisplay()
    }

    ///Отрисовывает подпись с начала и до конца
    func playSignature() {

        let path = UIBezierPath()

        //Отрисовку проводит по точкам, которые хранятся в массиве previousLines
        guard let firstPoint = signaturePath.first?.points.first else {return}
        path.move(to: firstPoint)

        for i in 0..<signaturePath.count {
            for j in 0..<signaturePath[i].points.count {
                if j == 0 {
                    path.move(to: signaturePath[i].points[j])
                } else {
                    path.addLine(to: signaturePath[i].points[j])
                }
            }
        }

        drawingLayer = CAShapeLayer()
        drawingLayer.path = path.cgPath
        drawingLayer.strokeEnd = 0
        drawingLayer.lineWidth = CGFloat(2.0)
        drawingLayer.strokeColor = UIColor.white.cgColor
        drawingLayer.fillColor = UIColor.clear.cgColor

        signatureView.layer.addSublayer(drawingLayer)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1

        animation.duration = 1.5
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false

        drawingLayer.add(animation, forKey: "signatureAnimation")
    }
}

//    Убирает клавиатуру при нажатии на пустое пространство

extension SettingsVC: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 18
       }
}

extension SettingsVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        signatureVCPresenter.isPresenting = true
        return signatureVCPresenter
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        signatureVCPresenter.isPresenting = false
        signatureVCPresenter.isDismissing = true
        return signatureVCPresenter
    }
}

extension SettingsVC: SetUsersSignaturePathProtocol {

    func setUserSignaturePath(path: [Line]) {
        clear()
        self.signaturePath = path
        topCardViewConstraint.constant = 13
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            self.createSignatureButton.alpha = 0
            self.signatureView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.playSignature()
        })
    }
}

extension SettingsVC: AnimationDirectionProtocol {

    /// Функция для того, чтобы задать направление анимации
    ///
    /// - Parameters:
    ///     - direction: Направление анимации
    func setDirection(direction: NavigationTitleAnimationDirection) {
        self.direction = direction
    }
}

extension SettingsVC: SetupContainerViewProtocol {

    func setupContainerView(container: UIView, containerColor: UIColor) {
         containerView.backgroundColor = containerColor
         containerView.translatesAutoresizingMaskIntoConstraints = false

         view.addSubview(containerView)
        containerView.setPosition(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
         containerView.roundCorners(cornerRadius: ThemeManager.Corner.containerViewCornerRadius)
     }
}
