//
//  Extension+UIViewController.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 05.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

extension UIViewController {

    /// Функция для анимирования заголовка Navigation Controller
    ///
    /// - Parameters:
    ///     - title: название заголовка
    ///     - direction: направление для анимации
    func addNavigationControllerTitleAnimation(navVC: UINavigationController, nextTitle: String, direction: NavigationTitleAnimationDirection) {

        let titleAnimation = CATransition()
        titleAnimation.duration = 0.22
        titleAnimation.type = CATransitionType.push
        titleAnimation.subtype = direction == .left ? CATransitionSubtype.fromLeft : CATransitionSubtype.fromRight
        titleAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)

            for navigationItem in navVC.navigationBar.subviews {

                for itemSubView in navigationItem.subviews {

                    if let largeLabel = itemSubView as? UILabel {
                        largeLabel.layer.add(titleAnimation, forKey: "changeTitle")
                    }
                }
            }

        navVC.viewControllers.first?.navigationItem.title = nextTitle
    }
}
