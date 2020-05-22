//
//  CircleDotView.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 16.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class CircledDotView: UIView {

    var mainColor: UIColor = .white {
        didSet {

        }
    }

    var isSelected: Bool = true

    override func draw(_ rect: CGRect) {
        translatesAutoresizingMaskIntoConstraints = false
        let dotPath = UIBezierPath(ovalIn: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        shapeLayer.fillColor = mainColor.cgColor
        layer.addSublayer(shapeLayer)

        if isSelected {
            drawRingFittingInsideView(rect: rect)
        }
    }

    internal func drawRingFittingInsideView(rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: 0, dy: 0))
        let shapeLayer = CAShapeLayer()

        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0
        layer.addSublayer(shapeLayer)
    }
}
