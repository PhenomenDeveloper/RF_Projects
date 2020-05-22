//
//  Extension+NavigationBar.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 05.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

extension UINavigationBar {

    /// Установка гридента для Navigation Bar
    ///
    /// - Parameters:
    ///     - view: вьюшка, которая отображает текущий экран
    ///     - startGradientColor: начальный цвет градиента
    ///     - endGradientColor: конечный цвет градиента
    func setupGradientNavigationBar(view: UIView, startGradientColor: CGColor, endGradientColor: CGColor) {
             let gradient = CAGradientLayer()
             var bounds = self.bounds
             bounds.size.height += view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
             gradient.frame = bounds
             gradient.colors = [startGradientColor, endGradientColor]
             gradient.startPoint = CGPoint(x: 0, y: 0)
             gradient.endPoint = CGPoint(x: 0, y: 0.7)

             if let image = getImageFrom(gradientLayer: gradient) {
                 self.setBackgroundImage(image, for: UIBarMetrics.default)
             }
     }

     /// Получение объекта UIImage из CAGradientLayer
     private func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage? {
         var gradientImage: UIImage?
         UIGraphicsBeginImageContext(gradientLayer.frame.size)
         if let context = UIGraphicsGetCurrentContext() {
             gradientLayer.render(in: context)
             gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
         }
         UIGraphicsEndImageContext()
         return gradientImage
     }
}
