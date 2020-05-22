//
//  NumPad.swift
//  SoNiceNumPad
//
//  Created by KOLESNIKOV Lev on 02/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import UIKit

enum Line {
    case first
    case second
    case third
    case fourth
}

protocol NumButtonTappedDelegate: class {
    // SCHOOL: про нейминг. onButtonTap - неплохое название для замыкания, например onButtonTap: (() -> Void)?. метод делегата принято назвать несколько иначе. Первый параметр - это всегда тот, кто отправляет сообщение. Например с параметрами - func numPad(_ numPad: NumPad, didReceiveButtonTap number: String) или без параметров - func numPadDidReceiveDeleteAction(_ numPad: NumPad)
    func numPad(_ numPad: NumPadView, didReceiveButtonTap number: String)
    func onDeleteButtonTap()
}

@IBDesignable
// SCHOOL: я бы назвал NumPadView - так понятнее, что это сабкласс UIView 
class NumPadView: UIView {
    
    private var numPad: [NumButton] = []
    
    private var primaryStackView = UIStackView()
    
    private var numFirstLineStackView = UIStackView()
    private var numSecondLineStackView = UIStackView()
    private var numThirdLineStackView = UIStackView()
    private var numFourthLineStackView = UIStackView()
    
    weak var delegate: NumButtonTappedDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        generateNumPad()
        
        primaryStackView.axis = .vertical
        primaryStackView.distribution = .equalSpacing
        primaryStackView.spacing = DeviceType.iPhoneSE ? NumPadConstants.SE.NumPadStackView.spacing : NumPadConstants.NumPadStackView.spacing
        primaryStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(primaryStackView)

        setupStackView(stackView: numFirstLineStackView, line: .first)
        setupStackView(stackView: numSecondLineStackView, line: .second)
        setupStackView(stackView: numThirdLineStackView, line: .third)
        setupStackView(stackView: numFourthLineStackView, line: .fourth)
        
        setupConstraints()
    }
    
    
    private func setupStackView(stackView: UIStackView, line: Line) {
        stackView.distribution = .equalSpacing
        stackView.spacing = DeviceType.iPhoneSE ? NumPadConstants.SE.NumPadStackView.spacing : NumPadConstants.NumPadStackView.spacing

        primaryStackView.addArrangedSubview(stackView)
        
        switch line {
        case .first:
            stackView.addArrangedSubview(numPad[1])
            stackView.addArrangedSubview(numPad[2])
            stackView.addArrangedSubview(numPad[3])
        case .second:
            stackView.addArrangedSubview(numPad[4])
            stackView.addArrangedSubview(numPad[5])
            stackView.addArrangedSubview(numPad[6])
        case .third:
            stackView.addArrangedSubview(numPad[7])
            stackView.addArrangedSubview(numPad[8])
            stackView.addArrangedSubview(numPad[9])
        case .fourth:
            let touchIdButton = createCustomButton(image: #imageLiteral(resourceName: "touchId"))
            let deleteSymbolButton = createCustomButton(image: #imageLiteral(resourceName: "icDeleteSymbol"))
            deleteSymbolButton.addTarget(self, action: #selector(deleteNumber), for: .touchUpInside)
           
            stackView.addArrangedSubview(touchIdButton)
            stackView.addArrangedSubview(numPad[0])
            stackView.addArrangedSubview(deleteSymbolButton)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        primaryStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        primaryStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
    }
    
    private func createCustomButton(image: UIImage) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.widthAnchor.constraint(equalToConstant: NumViewConstants.numViewSize).isActive = true
        return button
    }
    
    private func generateNumPad() {
        let model = NumModel()
        
        for i in 0..<model.letters.count {
            let numObject = NumButton(frame: CGRect(x: 0, y: 0, width: NumViewConstants.numViewSize, height: NumViewConstants.numViewSize))
            numObject.numberText = model.numbers[i]
            numObject.letterText = model.letters[i]
            // SCHOOL: так можно делать, но обычно target/action инкапсулируют внутри объекта. А наружу торчит или делегат или замыкание вида onTap/actionHandler() -> Void
            numObject.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
            numPad.append(numObject)
        }
    }
    
    @objc func handleTap(_ sender: NumButton) {
        guard let number = sender.numberText else { return }
        delegate?.numPad(self, didReceiveButtonTap: number)
        print(number)
    }
    
    @objc func deleteNumber(_ sender: UIButton) {
        delegate?.onDeleteButtonTap()
    }
}


