//
//  ConstraintsManager.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 04/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import UIKit

// MARK: - Менеджер Constraint
struct ConstraintsManager {
    struct InboxModule {

        struct InboxTableView {
            static let topInset: CGFloat = 34.0
        }

        struct CardView {

            static let topConstraint: CGFloat = 12.0
            static let leftConstraint: CGFloat = 16.0
            static let bottomConstraint: CGFloat = 12.0
            static let rightConstraint: CGFloat = 16.0
        }

        struct TimeLabel {

            static let topConstraint: CGFloat = 20.0
            static let leftConstraint: CGFloat = 0.0
            static let bottomConstraint: CGFloat = 40.0
            static let rightConstraint: CGFloat = 10.0
        }

        struct OperationTypeLabel {

            static let topConstraint: CGFloat = 16.0
            static let leftConstraint: CGFloat = 12.0
            static let bottomConstraint: CGFloat = 0.0
            static let rightConstraint: CGFloat = 58.0
        }

        struct NameLabel {

            static let topConstraint: CGFloat = 4.0
            static let leftConstraint: CGFloat = 0.0
            static let bottomConstraint: CGFloat = 12.0
            static let rightConstraint: CGFloat = 58.0
        }
    }

}
