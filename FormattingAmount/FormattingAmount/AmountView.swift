//
//  AmountView.swift
//  FormattingAmount
//
//  Created by Lev Kolesnikov on 22.01.2020.
//  Copyright © 2020 SwiftOverflow. All rights reserved.
//

import UIKit

class AmountView: UIView {
    
    var amountIsHidden: Bool = false
    var securityData = ("***","","")
    var currentData = ("","","")
    
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = .white
        label.text = "999"
        return label
    }()
    
    let pennyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.text = ",22"
        return label
    }()
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.text = "₽"
        return label
    }()
    
    let securityEyeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "eyeClosed"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(securityEyeTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    @objc func securityEyeTapped()
    {
        amountIsHidden = !amountIsHidden
        
        if amountIsHidden {
            guard let main = mainLabel.text, let penny = pennyLabel.text, let currency = currencyLabel.text else { return }
            currentData = (main, penny, currency)
            
            mainLabel.text = securityData.0
            pennyLabel.text = securityData.1
            currencyLabel.text = securityData.2
        } else {
            mainLabel.text = currentData.0
            pennyLabel.text = currentData.1
            currencyLabel.text = currentData.2
        }
    }
    
    private func setupConstraints() {
        
//        self.backgroundColor = .clear
        
        addSubview(contentView)
        
        contentView.fillToSuperView(view: self)
        
        contentView.addSubview(securityEyeButton)

        securityEyeButton.setPosition(top: nil,
                                      left: contentView.leftAnchor,
                                      bottom: nil,
                                      right: nil,
                                         paddingTop: 0,
                                         paddingLeft: 8,
                                         paddingBottom: 0,
                                         paddingRight: 0,
                                         width: 24,
                                         height: 24)
        
        securityEyeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

//        contentView.addSubview(mainLabel)
//
//        mainLabel.setPosition(top: contentView.topAnchor,
//                              left: securityEyeButton.rightAnchor,
//                              bottom: contentView.bottomAnchor,
//                              right: nil,
//                              paddingTop: 0,
//                              paddingLeft: 8,
//                              paddingBottom: 0,
//                              paddingRight: 0,
//                              width: 0,
//                              height: 0)
//
//        mainLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//
//        addSubview(pennyLabel)
//
//        pennyLabel.setPosition(top: topAnchor,
//                               left: mainLabel.rightAnchor,
//                               bottom: bottomAnchor,
//                               right: nil,
//                               paddingTop: 0,
//                               paddingLeft: 1,
//                               paddingBottom: 0,
//                               paddingRight: 0,
//                               width: 0,
//                               height: 0)
//
//        addSubview(currencyLabel)
//
//        currencyLabel.setPosition(top: topAnchor,
//                                  left: pennyLabel.rightAnchor,
//                                  bottom: bottomAnchor,
//                                  right: nil,
//                                  paddingTop: 0,
//                                  paddingLeft: 4,
//                                  paddingBottom: 0,
//                                  paddingRight: 0,
//                                  width: 0,
//                                  height: 0)
        
    }
}



