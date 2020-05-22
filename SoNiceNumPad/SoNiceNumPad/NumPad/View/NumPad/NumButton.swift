//
//  Num.swift
//  SoNiceNumPad
//
//  Created by KOLESNIKOV Lev on 02/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import UIKit

// SCHOOL: IBDesignable в итоге не попробовал, насколько я вижу?
@IBDesignable
class NumButton: UIControl {
    
    let numSize: CGFloat = DeviceType.iPhoneSE ? NumPadConstants.SE.NumViewConstants.numViewSize  : NumViewConstants.numViewSize
    
    @IBInspectable var numberText: String? {
        didSet {
            self.numberLabel.text = numberText
        }
    }
    
    @IBInspectable var letterText: String? {
        didSet {
            self.letterLabel.text = letterText
        }
    }
    
    private var numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.numberFontSize, weight: .light)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var letterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.letterFontSize, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: self.isHighlighted ? 0 : 0.35, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.alpha = self.isHighlighted ? 0.25 : 1
            })
        }
    }
    
// SCHOOL: я бы разделил этот метод на два - первый [setup()] выполнял одноразовые действия, вроде addSubview и backgroundColor. А второй [updateLayout()] только то, что зависит от размера, например cornerRadius. В итоге первый бы вызывался только на init, второй только на layoutSubviews. Сейчас же у тебя получается на каждый эвент layoutSubviews (а их может быть очень много) вызывается и добавление subview, и добавление constraints, хотя они не изменяются.
    private func setupButton() {
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.3019607843, blue: 0.3215686275, alpha: 1)
        self.clipsToBounds = true
        
        self.addSubview(numberLabel)
        self.addSubview(letterLabel)
        
//        setupConstraints()
    }
    
    private func updateLayout() {
        self.layer.cornerRadius = layer.frame.width / 2
// LEV: Правильно ли устанавливать Constraints в layoutSubviews()?
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
        self.heightAnchor.constraint(equalToConstant: numSize),
        self.widthAnchor.constraint(equalToConstant: numSize)])
        
// SCHOOL: у тебя получилось, что кнопка с 0 не выровнена по центру, как на дизайне
        if letterText != nil {
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: DeviceType.iPhoneSE ? NumPadConstants.NumberLabel.topSEConstraintValue : NumPadConstants.NumberLabel.topConstraintValue).isActive = true
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            letterLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor).isActive = true
            letterLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        } else {
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
}
