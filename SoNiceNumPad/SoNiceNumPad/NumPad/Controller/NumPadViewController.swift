//
//  ViewController.swift
//  SoNiceNumPad
//
//  Created by KOLESNIKOV Lev on 02/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import UIKit

class NumPadViewController: UIViewController {
    
    let pinCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.pinCodeFontSize, weight: .regular)
        label.text = "Pin Code"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.6604230343, green: 0.6637075403, blue: 0.6662865058, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradient()
        setupPinCodeLabel()
        setupNumPad()
        setupPinStackView()
        
    }
    
    private func setupGradient() {
        let gradientView = NumGradient(frame: view.frame)
        gradientView.startColor = #colorLiteral(red: 0.1215686275, green: 0.137254902, blue: 0.1490196078, alpha: 1)
        gradientView.endColor = #colorLiteral(red: 0.2745098039, green: 0.2862745098, blue: 0.2980392157, alpha: 1)
        
        self.view.addSubview(gradientView)
    }
    
    
    private func setupPinStackView() {
        let pinView: PinView = PinView()
        pinView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(pinView)
        
        NSLayoutConstraint.activate([
            pinView.topAnchor.constraint(equalTo: pinCodeLabel.bottomAnchor, constant: NumPadConstants.PinStackView.topConstraintValue),
            pinView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupPinCodeLabel() {
        
        self.view.addSubview(pinCodeLabel)
        
        NSLayoutConstraint.activate([
            pinCodeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: PinCodeConstants.topConstraintValue),
            pinCodeLabel.heightAnchor.constraint(equalToConstant: PinCodeConstants.height),
            pinCodeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: PinCodeConstants.width),
            pinCodeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    private func setupNumPad() {
        
        let numPad = NumPadView()
        numPad.delegate = self
        
        numPad.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(numPad)
        NSLayoutConstraint.activate([
            numPad.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NumPadConstants.NumPadStackView.topConstraintValue),
            numPad.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: NumPadConstants.NumPadStackView.leftConstraintValue),
            numPad.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: NumPadConstants.NumPadStackView.rightConstraintValue),
            numPad.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: DeviceType.iPhoneSE ? NumPadConstants.SE.NumPadStackView.bottomConstraintValue : NumPadConstants.NumPadStackView.bottomConstraintValue)
        ])
    }
    
}
extension NumPadViewController: NumButtonTappedDelegate {

    func numPad(_ numPad: NumPadView, didReceiveButtonTap number: String) {
        
        if pinCodeLabel.text == "Pin Code" {
            pinCodeLabel.text = ""
            pinCodeLabel.text! += number
        } else {
            guard pinCodeLabel.text!.count < 4 else { return }
            pinCodeLabel.text! += number
        }
    }
    
    func onDeleteButtonTap() {
        
        if pinCodeLabel.text!.count > 0 && pinCodeLabel.text != "Pin Code" {
            pinCodeLabel.text?.removeLast()
        } else if pinCodeLabel.text?.count == 0 {
            pinCodeLabel.text = "Pin Code"
        }
    }
}


