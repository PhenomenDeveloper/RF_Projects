//
//  Protocols.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 06/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation
import UIKit

protocol GoToUserSettings {

    func gotoUserSettings()
}

protocol GoToMainVC: class {
    func goToMainVC()
}

protocol AuthorizationDelegate: class {
    func authorization()
}

protocol GoToStreetBallVC {
    func goToStreetBallVC()
}

protocol AnimationDirectionProtocol {
    func setDirection(direction: NavigationTitleAnimationDirection)
}

protocol SetupContainerViewProtocol {

    var containerView: UIView { get }

    func setupContainerView(container: UIView, containerColor: UIColor)
}
