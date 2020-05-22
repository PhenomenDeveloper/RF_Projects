//
//  DeviceType.swift
//  SoNiceNumPad
//
//  Created by KOLESNIKOV Lev on 03/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenMaxLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
    static let iPhoneSE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
}
