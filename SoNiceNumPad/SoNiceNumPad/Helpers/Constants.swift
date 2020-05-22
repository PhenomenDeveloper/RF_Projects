//
//  Constants.swift
//  SoNiceNumPad
//
//  Created by Lev Kolesnikov on 02.12.2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import UIKit

struct NumViewConstants {
    static let numViewSize: CGFloat = 82.0
}

struct NumPadConstants {
    
    static let pinStackCount: Int = 4
    
    struct SE {
        
        struct NumViewConstants {
           static let numViewSize: CGFloat = 72.0
        }
        
        struct NumPadStackView {
            static let spacing: CGFloat = 16.0
            static let bottomConstraintValue: CGFloat = -20
        }
    }

    struct NumberLabel {
        static let topConstraintValue: CGFloat = 13.0
        static let topSEConstraintValue: CGFloat = 4.0
    }
    
    struct NumPadStackView {
        static let spacing: CGFloat = 32.0
        
        static let topConstraintValue: CGFloat = 200.0
        static let leftConstraintValue: CGFloat = 30.0
        static let rightConstraintValue: CGFloat = -30.0
        static let bottomConstraintValue: CGFloat = -10.0
    }
    
    struct PinStackView {
        static let spacing: CGFloat = 12.0
        static let topConstraintValue: CGFloat = 30.0
    }
}

struct PinCodeConstants {
    static let pinSize: CGFloat = 15.0
    static let topConstraintValue: CGFloat = 96.0
    static let height: CGFloat = 19.0
    static let width: CGFloat = 66.0
}

struct FontSize {
    static let pinCodeFontSize: CGFloat = 16.0
    static let numberFontSize: CGFloat = 36.0
    static let letterFontSize: CGFloat = 9.0
}


