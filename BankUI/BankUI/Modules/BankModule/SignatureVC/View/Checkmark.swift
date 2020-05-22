//
//  Checkmark.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 06.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

public class Checkmark: UIView {

    // MARK: Публичные свойства
    public var initialLayerColor: UIColor = UIColor.blue {
        didSet {
            initialLayer.strokeColor = initialLayerColor.cgColor
        }
    }
    public var animatedLayerColor: UIColor = UIColor.red {
        didSet {
            animatedLayer?.strokeColor = animatedLayerColor.cgColor
        }
    }
    public var strokeWidth: CGFloat = 4 {
        didSet {
            initialLayer.lineWidth = strokeWidth
            animatedLayer?.lineWidth = strokeWidth
        }
    }
    public var animated: Bool = false {
        didSet {
            if animated {
                animatedLayer = createCheckmarkLayer(strokeColor: animatedLayerColor, strokeEnd: 0)
                layer.addSublayer(animatedLayer!)
            }
        }
    }

    // MARK: Приватные Свойства
    private lazy var initialLayer: CAShapeLayer = {
        return self.createCheckmarkLayer(strokeColor: self.initialLayerColor, strokeEnd: 1)
    }()
    private var animatedLayer: CAShapeLayer?

    // MARK: Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
    }

    // MARK: Публичные методы
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configureView()
    }
    public func animate(duration: TimeInterval = 0.3) {
        guard let animatedLayer = animatedLayer else { return }

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.duration = duration

        animatedLayer.strokeEnd = 1
        animatedLayer.add(animation, forKey: "animateCheckmark")
    }

    // MARK: Приватные методы
    private func configureView() {
        backgroundColor = UIColor.clear
        initialLayerColor = #colorLiteral(red: 0.2745098039, green: 0.2862745098, blue: 0.2980392157, alpha: 1)
        animatedLayerColor = #colorLiteral(red: 1, green: 0.8588235294, blue: 0, alpha: 1)
        strokeWidth = 3
        animated = false

        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true

        layer.addSublayer(initialLayer)
    }
    private func createCheckmarkLayer(strokeColor: UIColor, strokeEnd: CGFloat) -> CAShapeLayer {
        let scale = frame.width / 40
        let centerX = frame.size.width / 2
        let centerY = frame.size.height / 2

        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: centerX - 23 * scale, y: centerY - 1 * scale))
        checkmarkPath.addLine(to: CGPoint(x: centerX - 6 * scale, y: centerY + 15.9 * scale))
        checkmarkPath.addLine(to: CGPoint(x: centerX + 22.8 * scale, y: centerY - 13.4 * scale))

        let checkmarkLayer = CAShapeLayer()
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        checkmarkLayer.lineWidth = strokeWidth
        checkmarkLayer.path = checkmarkPath.cgPath
        checkmarkLayer.strokeEnd = strokeEnd
        checkmarkLayer.strokeColor = strokeColor.cgColor
        checkmarkLayer.lineCap = CAShapeLayerLineCap.round
        checkmarkLayer.lineJoin = CAShapeLayerLineJoin.round

        return checkmarkLayer
    }

}
