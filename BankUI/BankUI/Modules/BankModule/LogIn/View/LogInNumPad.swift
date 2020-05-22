//
//  LogInNumPad.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class LoginNumPad: UIView {

    // MARK: - Свойства

    ///Модель для заполнения кнопок нужными цифрами и буквами
    let model = NumPadModel()

    ///Стек содержащий индикаторы ввода pin
    var pinIndicators: UIStackView = UIStackView()
    //Стеки содержащий в себе ряды для NumPad
    let stackFirst: UIStackView = UIStackView()
    let stackSecond: UIStackView = UIStackView()
    let stackThird: UIStackView = UIStackView()
    let stackEnd: UIStackView = UIStackView()
    weak var delegate: GoToMainVC?
    var delegateBio: AuthorizationDelegate?

    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "biometry status"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.isHidden = false
        return label
    }()

    ///Надпись Pin Code на экране
    let pinCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "PIN"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        return label
    }()

    ///Кнопка авторизации по биометрике
    let verificationButton = CustomButtonImage(frame: CGRect(x: 0, y: 0, width: 44, height: 44))

    ///Содержит пинкод введенный пользователем
    var inputText = ""

    ///Перечисление линий в NumPad
    private enum LineForNumPad {
        case first, second, third, end
    }

    // MARK: - Инициализация

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUiComponents()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUiComponents()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = nil
    }

    // MARK: - Расстановка UI компонентов

    ///Расставляет все UI элементы по местам
    private func setUpUiComponents() {

        setupPinLabel()
        setupPinIndicators()
        configureNumPad(line: .first)
        configureNumPad(line: .second)
        configureNumPad(line: .third)
        configureNumPad(line: .end)
    }

    ///Устанавливает надпись Pin Code
    private func setupPinLabel() {
        let labelPadding = getConstantForDifferentPhone()
        addSubview(pinCodeLabel)
        pinCodeLabel.setPosition(top: nil, left: nil, bottom: topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: CGFloat(labelPadding), paddingRight: 0, width: 0, height: 0)
        pinCodeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    ///Устанавливает поле ввода Пин кода
    private func setupPinIndicators(isFirstFill: Bool = false, isSecondFill: Bool = false, isThirdFill: Bool = false, isFourthFill: Bool = false) {
        if self.subviews.contains(pinIndicators) {
            pinIndicators.removeFromSuperview()
        }
        pinIndicators = UIStackView()
        pinIndicators.axis = .horizontal
        pinIndicators.distribution = .equalSpacing
        pinIndicators.spacing = 12.0
        pinIndicators.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(pinIndicators)

        let first = PinIndicator()
        first.isFill = isFirstFill
        let second = PinIndicator()
        second.isFill = isSecondFill
        let third = PinIndicator()
        third.isFill = isThirdFill
        let fourth = PinIndicator()
        fourth.isFill = isFourthFill

        pinIndicators.addArrangedSubview(first)
        pinIndicators.addArrangedSubview(second)
        pinIndicators.addArrangedSubview(third)
        pinIndicators.addArrangedSubview(fourth)

        pinIndicators.setPosition(top: pinCodeLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        NSLayoutConstraint.activate([
            pinIndicators.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    ///Устанавливает нужную строку  NumPad на экране
    /// - Parameters:
    ///     - line: Строка NumPad
    private func configureNumPad(line: LineForNumPad) {

        switch line {
        //Первый ряд кнопок
        case .first:
            setLine(from: 0, to: 3, stack: stackFirst)
            stackFirst.setPosition(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 18, paddingBottom: 0, paddingRight: 18, width: 0, height: 82)
        //Второй ряд кнопок
        case .second:
            setLine(from: 3, to: 6, stack: stackSecond)
            stackSecond.setPosition(top: stackFirst.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 18, paddingBottom: 0, paddingRight: 18, width: 0, height: 82)
        //Третий ряд кнопок
        case .third:
            setLine(from: 6, to: 9, stack: stackThird)
            stackThird.setPosition(top: stackSecond.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 18, paddingBottom: 0, paddingRight: 18, width: 0, height: 82)

        //Последний ряд кнопок
        case .end:

            verificationButton.addTarget(self, action: #selector(verificationButtonTapped), for: .touchUpInside)
            verificationButton.setPosition(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 82, height: 82)

            let zeroButton = CustomButton(frame: CGRect(x: 0, y: 0, width: 82, height: 82))
            zeroButton.titleText = "0"
            zeroButton.addTarget(self, action: #selector(numPadTapped(sender:)), for: .touchUpInside)
            zeroButton.setTitles()
            zeroButton.setPosition(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 82, height: 82)

            let clearButton = CustomButtonImage(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            clearButton.image = UIImage(named: "icDeleteSymbol")
            clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
            clearButton.setPosition(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 82, height: 82)

            stackEnd.addArrangedSubview(verificationButton)
            stackEnd.addArrangedSubview(zeroButton)
            stackEnd.addArrangedSubview(clearButton)
            self.addSubview(stackEnd)
            stackEnd.axis = .horizontal
            stackEnd.distribution = .equalSpacing
            stackEnd.setPosition(top: stackThird.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 18, paddingBottom: 0, paddingRight: 18, width: 0, height: 82)
        }

    }
    // MARK: - Вспомогательные функции

    public func clearDots() {
        setupPinIndicators()
        inputText = ""
    }

    ///Определяет какие кружочки должны быть закрашены
    /// - Parameters:
    ///     - count: Количество кружочков для закрашивания
    func setPinIndicatorsFill(count: Int) {
        switch count {
        case 0:
            setupPinIndicators()
        case 1:
            setupPinIndicators(isFirstFill: true)
        case 2:
            setupPinIndicators(isFirstFill: true, isSecondFill: true)
        case 3:
            setupPinIndicators(isFirstFill: true, isSecondFill: true, isThirdFill: true)
        case 4:
            setupPinIndicators(isFirstFill: true, isSecondFill: true, isThirdFill: true, isFourthFill: true)
        default:
            break
        }
    }

    ///Устанавливает элементы в строке NumPad
    ///
    /// - Parameters:
    ///     - from: От какого индекса берем данные из модели
    ///     - to: До какого индекса берем данные из модели
    ///     - stack: UIStackView в котором устанавливаются элементы
    private func setLine(from: Int, to: Int, stack: UIStackView) {
        for i in from..<to {
            let button = CustomButton(frame: CGRect(x: 0, y: 0, width: 82, height: 82))
            button.titleText = model.titles[i]
            button.subTitleText = model.subTitles[i]
            button.setPosition(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 82, height: 82)
            button.addTarget(self, action: #selector(numPadTapped(sender:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
            self.addSubview(stack)
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
        }
    }

    ///Возвращает высота для расположения поля для ввода Пин кода
    /// - Returns:
    ///     Возвращает необходимую высоту
    private func getConstantForDifferentPhone() -> Int {
        switch DeviceType.getCurrentPhoneOfUser() {
        case .iphone4:
            return 3
        case .iphone5SE:
            return 50
        case .iphone8:
            return 120
        case .iphone8Plus:
            return 170
        case .iphone11Pro:
            return 180
        case .iphone11:
            return 230
        case .iphone11ProMax:
            return 250
        }
    }

    // MARK: - Обработка нажатий

    ///Нажата кнопка верификации по биометрике
    @objc func verificationButtonTapped() {

        self.delegateBio?.authorization()
    }

    ///Нажата кнопка NumPada
    @objc func numPadTapped(sender: CustomButton) {
        guard inputText.count < 4 else {return}
        if let text = sender.titleText {
            inputText += text
            setPinIndicatorsFill(count: inputText.count)
            if inputText.count == 4 {
                if Keychain.pinConfirm(pin: inputText) {
                    confirmPinAnimation()
                    self.delegate?.goToMainVC()
                    let passwordDebug = Keychain.password(service: Keychain.service, account: Keychain.passwordAccount)
                    print("passwordDebug = \(passwordDebug)")
                } else {
                    setupPinIndicators()
                    shakeAnimation()
                    inputText = ""
                }
            }
        }
    }

    ///Нажата кнопка стереть текст
    @objc func clearButtonTapped() {
        if inputText.count > 0 {
            inputText.removeLast()
            setPinIndicatorsFill(count: inputText.count)
        }
    }

    ///Анимация неправильного ПИН
    private func shakeAnimation() {

        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        pinIndicators.layer.add(animation, forKey: "shake")
    }

    ///Анимация правильного ПИН
    func confirmPinAnimation() {

        setupPinIndicators(isFirstFill: true, isSecondFill: true, isThirdFill: true, isFourthFill: true)

        UIView.animate(withDuration: 0.4, delay: 0, options: [.repeat, .autoreverse], animations: {
            let firstPinIndicator = self.pinIndicators.arrangedSubviews[0] as? PinIndicator
            firstPinIndicator?.alpha = 0.5
        }, completion: nil)

        UIView.animate(withDuration: 0.4, delay: 0.1, options: [.repeat, .autoreverse], animations: {
            let secondPinIndicator = self.pinIndicators.arrangedSubviews[1] as? PinIndicator
            secondPinIndicator?.alpha = 0.5
        }, completion: nil)

        UIView.animate(withDuration: 0.4, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            let thirdPinIndicator = self.pinIndicators.arrangedSubviews[2] as? PinIndicator
            thirdPinIndicator?.alpha = 0.5
        }, completion: nil)

        UIView.animate(withDuration: 0.4, delay: 0.3, options: [.repeat, .autoreverse], animations: {
            let fourthPinIndicator = self.pinIndicators.arrangedSubviews[3] as? PinIndicator
            fourthPinIndicator?.alpha = 0.5
        }, completion: nil)
    }
}
