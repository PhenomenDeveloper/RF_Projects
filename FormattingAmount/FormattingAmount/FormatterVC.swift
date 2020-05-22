//
//  FormatterVC.swift
//  FormattingAmount
//
//  Created by Lev Kolesnikov on 22.01.2020.
//  Copyright © 2020 SwiftOverflow. All rights reserved.
//

import UIKit

class FormatterVC: UIViewController {
    
    let amountFormatter = AmountFormatter()
    
    // MARK: - Создание UI элементов
    
    let cardView: UIView = UIView()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["₽", "$", "€"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 1, green: 0.8588235294, blue: 0, alpha: 1)
        segmentedControl.backgroundColor = .white
        return segmentedControl
    }()
    
    let amountView: AmountView = AmountView()
    
    lazy var amountTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.tintColor = #colorLiteral(red: 1, green: 0.8588235294, blue: 0, alpha: 1)
        textField.placeholder = "Введите сумму"
        
        return textField
    }()
    
    var confirmButton : UIButton = {
       let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 1, green: 0.8588235294, blue: 0, alpha: 1)
        button.setTitle("Подтвердить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(setupData), for: .touchUpInside)
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupConstraints()
        setupData()
    }
    
    private func setupNavigationBar() {
        title = "Сумма"
    }
    
    // MARK: - Функции для форматирования суммы
    @objc private func setupData() {
        
        var amount: Decimal = 0
        
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = NumberFormatter.Style.decimal
        
        guard let amountTextField = amountTextField.text else { return }
        
        if let formattedNumber = formatter.number(from: amountTextField) as? NSDecimalNumber  {
            amount = formattedNumber as Decimal

            switch segmentedControl.selectedSegmentIndex {
            case 0:
                
                if amount == 0 {
                    setupZeroAmount(currency: .rub)
                } else if !amountTextField.contains(".") {
                    setupWholeAmount(amount: amount, currency: .rub)
                }
                
                let amountStr = amountFormatter.formatter(amount: amount, currency: .rub)
                amountView.currencyLabel.text = Currency.rub.rawValue
                
                guard let result = amountStr else { return }
                let temp = result.replacingOccurrences(of: Currency.rub.rawValue, with: "")
                
                let commaIndex = result.firstIndex(of: ",")
                guard let index = commaIndex else { return }
                amountView.mainLabel.text = String(temp.prefix(upTo: index))
                amountView.pennyLabel.text = String(temp.suffix(from: index))
            case 1:
                
                if amount == 0 {
                     setupZeroAmount(currency: .usd)
                 } else if !amountTextField.contains(".") {
                     setupWholeAmount(amount: amount, currency: .usd)
                 }
                
                let amountStr = amountFormatter.formatter(amount: amount, currency: .usd)
                amountView.currencyLabel.text = Currency.usd.rawValue
                
                guard let result = amountStr else { return }
                let temp = result.replacingOccurrences(of: Currency.usd.rawValue, with: "")
                
                let commaIndex = result.firstIndex(of: ",")
                guard let index = commaIndex else { return }
                amountView.mainLabel.text = String(temp.prefix(upTo: index))
                amountView.pennyLabel.text = String(temp.suffix(from: index))
            case 2:
                
                if amount == 0 {
                     setupZeroAmount(currency: .eur)
                 } else if !amountTextField.contains(".") {
                     setupWholeAmount(amount: amount, currency: .eur)
                 }
                
                let amountStr = amountFormatter.formatter(amount: amount, currency: .eur)
                amountView.currencyLabel.text = Currency.eur.rawValue
                
                guard let result = amountStr else { return }
                let temp = result.replacingOccurrences(of: Currency.eur.rawValue, with: "")
                
                let commaIndex = result.firstIndex(of: ",")
                guard let index = commaIndex else { return }
                amountView.mainLabel.text = String(temp.prefix(upTo: index))
                amountView.pennyLabel.text = String(temp.suffix(from: index))
            default:
                print("Oh no, no, no!😱")
            }
        }
    }
    
    private func setupZeroAmount(currency: Currency) {
        amountView.mainLabel.text = "0"
        amountView.pennyLabel.text = ",00"
        amountView.currencyLabel.text = currency.rawValue
    }
    
    private func setupWholeAmount(amount: Decimal, currency: Currency) {
        amountView.mainLabel.text = "\(amount)"
        amountView.pennyLabel.text = ""
        amountView.currencyLabel.text = currency.rawValue
    }
    
    // MARK: - Установка Constraints для UI элементов
    private func setupConstraints() {
        
        view.addSubview(cardView)
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        cardView.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.2862745098, blue: 0.2980392157, alpha: 1)
        
        cardView.setPosition(top: view.topAnchor,
                             left: view.leftAnchor,
                             bottom: nil,
                             right: view.rightAnchor,
                             paddingTop: 50,
                             paddingLeft: 20,
                             paddingBottom: 0,
                             paddingRight: 20,
                             width: 0,
                             height: 50)
        
        cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cardView.addSubview(amountView)
        

//        amountView.setPosition(top: nil,
//                               left: nil,
//                               bottom: nil,
//                               right: nil,
//                               paddingTop: 15,
//                               paddingLeft: 0,
//                               paddingBottom: 0,
//                               paddingRight: 0,
//                               width: 0,
//                               height: 0)

        amountView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        amountView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        
        view.addSubview(segmentedControl)
        
        segmentedControl.setPosition(top: cardView.bottomAnchor,
                                     left: cardView.leftAnchor,
                                     bottom: nil,
                                     right: cardView.rightAnchor,
                                     paddingTop: 20,
                                     paddingLeft: 0,
                                     paddingBottom: 0,
                                     paddingRight: 0,
                                     width: 0,
                                     height: 0)
        
        view.addSubview(amountTextField)
        
        amountTextField.setPosition(top: segmentedControl.bottomAnchor,
                                    left: view.leftAnchor,
                                    bottom: nil,
                                    right: view.rightAnchor,
                                    paddingTop: 30,
                                    paddingLeft: 20,
                                    paddingBottom: 0,
                                    paddingRight: 20,
                                    width: 0,
                                    height: 0)
        
        view.addSubview(confirmButton)
        
        confirmButton.setPosition(top: amountTextField.bottomAnchor,
                                  left: amountTextField.leftAnchor,
                                  bottom: nil,
                                  right: amountTextField.rightAnchor,
                                  paddingTop: 15,
                                  paddingLeft: 0,
                                  paddingBottom: 0,
                                  paddingRight: 0,
                                  width: 0,
                                  height: 56)
        
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}

// MARK: - UITextFieldDelegate
extension FormatterVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
