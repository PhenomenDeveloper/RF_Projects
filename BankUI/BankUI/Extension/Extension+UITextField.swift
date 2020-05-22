//
//  Extension+UITextField.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 04/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import UIKit

extension UITextField {

    func setBottomBorder(borderColor: UIColor) {
        self.layer.backgroundColor = backgroundColor?.cgColor

        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowColor = borderColor.cgColor
    }
}
