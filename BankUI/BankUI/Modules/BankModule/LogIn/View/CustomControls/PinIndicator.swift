//
//  PinIndicator.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class PinIndicator: UIButton {

    // MARK: - Свойства

    private var pinSize: CGFloat = 15.0
    public var isFill = false

    // MARK: - Инициализаторы

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

    // MARK: - Настройка внешнего вида для control

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCircle(rect)
    }

    public func drawCircle(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let rect = CGRect(x: rect.origin.x + 0.5,
                          y: rect.origin.y + 0.5,
                          width: rect.width - 1.5,
                          height: rect.height - 1.5)

        context.setLineWidth(1)

        switch isFill {
        case true:
            context.setFillColor(#colorLiteral(red: 0.990418613, green: 0.8784220815, blue: 0, alpha: 1))
            context.fillEllipse(in: rect)
        case false:
            context.setStrokeColor(UIColor.white.cgColor)
            context.strokeEllipse(in: rect)
        }

    }

    private func setupConstraints() {
        self.isUserInteractionEnabled = false
        self.setPosition(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: pinSize, height: pinSize)
    }
}
