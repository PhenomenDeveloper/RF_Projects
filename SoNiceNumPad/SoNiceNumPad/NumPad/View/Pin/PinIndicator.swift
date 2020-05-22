//
//  PinIndicator.swift
//  SoNiceNumPad
//
//  Created by KOLESNIKOV Lev on 03/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import UIKit

@IBDesignable
class PinIndicator: UIButton {
        
    private var pinSize: CGFloat = PinCodeConstants.pinSize
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCircle(rect)
    }
    
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
    
   private func drawCircle(_ rect:CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let rect = CGRect(x: rect.origin.x + 0.5,
                          y: rect.origin.y + 0.5,
                          width: rect.width - 1.5,
                          height: rect.height - 1.5)
        
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokeEllipse(in: rect)
    
//    context.setFillColor(UIColor.white.cgColor)
//    context.fillEllipse(in: rect)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        self.heightAnchor.constraint(equalToConstant: pinSize),
        self.widthAnchor.constraint(equalToConstant: pinSize)])
    }
}
