//
//  CheckBox.swift
//  BirdBox
//
//  Created by Виктор Корнеев on 16.01.2020.
//  Copyright © 2020 Viktor Korneev. All rights reserved.
//

import UIKit

class CheckBoxView: UIButton {

    let cornerRadius: CGFloat = 2.0
    let animationOffset: CGFloat = 5.0
    let animationDuration: CFTimeInterval = 0.3

   var fillColor: UIColor  = #colorLiteral(red: 0.9960784314, green: 0.8392156863, blue: 0.03921568627, alpha: 1)

    var tickMarkColor: UIColor  = #colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)

    var borderThickness: CGFloat = 2.0 {
        didSet {
            checkboxLyr.lineWidth = borderThickness
            checkboxLyr.displayIfNeeded()
        }
    }

    var borderColor: UIColor  = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) {
        didSet {
            checkboxLyr.strokeColor = self.borderColor.cgColor
            checkboxLyr.displayIfNeeded()
        }
    }

    private var checkBoxLayer: CAShapeLayer!
    private var tickMarkLayer: CAShapeLayer!

    private var checkBoxPathBig: UIBezierPath!
    private var checkBoxPathSmall: UIBezierPath!
    private var checkboxFrame: CGRect! {
        didSet {
            checkBoxPathBig = UIBezierPath(roundedRect: CGRect(x: checkboxFrame.origin.x-animationOffset,
                                                               y: checkboxFrame.origin.y-animationOffset,
                                                               width: checkboxFrame.size.width+(animationOffset*2),
                                                               height: checkboxFrame.size.height+(animationOffset*2)),
                                           cornerRadius: cornerRadius)
            checkBoxPathSmall = UIBezierPath(roundedRect: checkboxFrame, cornerRadius: cornerRadius)
        }
    }

    let checkboxLyr = CAShapeLayer()
    override var frame: CGRect {
        didSet {

            let viewBounds: CGRect = self.bounds
            checkboxFrame = CGRect(x: viewBounds.origin.x+animationOffset,
                                   y: viewBounds.origin.y+animationOffset,
                                   width: viewBounds.size.width-(animationOffset*2),
                                   height: viewBounds.size.height-(animationOffset*2))

            let checkBoxPath = UIBezierPath(roundedRect: checkboxFrame,
                                            cornerRadius: cornerRadius)

            checkboxLyr.fillColor = UIColor.clear.cgColor
            checkboxLyr.strokeColor = self.borderColor.cgColor
            checkboxLyr.lineWidth = borderThickness
            checkboxLyr.path = checkBoxPath.cgPath

            guard let sublayers = self.layer.sublayers else {
                self.layer.addSublayer(checkboxLyr)
                return
            }

            if !sublayers.contains(checkboxLyr) {
                self.layer.addSublayer(checkboxLyr)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var isSelected: Bool {
        didSet {
            if !isSelected && tickMarkLayer != nil {
                self.uncheckAnimation()
                self.checkboxLyr.lineWidth = 2.0
                return
            }
            checkAnimation()

            self.checkboxLyr.lineWidth = 0.0
        }
    }

    func checkAnimation() {
        if self.checkBoxLayer == nil {
            checkBoxLayer = CAShapeLayer()
            checkBoxLayer.fillColor = self.fillColor.cgColor
            checkBoxLayer.path = checkBoxPathSmall.cgPath

            self.layer.addSublayer(checkBoxLayer)
        }

        let x = checkboxFrame.origin.x
        let y = checkboxFrame.origin.y
        let w = checkboxFrame.size.width
        let h = checkboxFrame.size.height

        let startPoint: CGPoint = CGPoint(x: x+(w*0.20), y: y+(h*0.50))
        let midPoint: CGPoint = CGPoint(x: x+(w*0.40), y: y+(h*0.70))
        let endPoint: CGPoint = CGPoint(x: x+(w*0.80), y: y+(h*0.20))

        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: midPoint)
        path.addLine(to: endPoint)

        self.tickMarkLayer = CAShapeLayer()
        tickMarkLayer.fillColor = UIColor.clear.cgColor
        tickMarkLayer.strokeColor = self.tickMarkColor.cgColor
        tickMarkLayer.lineWidth = 2.0
        self.tickMarkLayer.lineJoin = CAShapeLayerLineJoin.round
        tickMarkLayer.path = path.cgPath

        let selectAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        selectAnimation.fromValue = checkBoxPathBig.cgPath
        selectAnimation.toValue = checkBoxPathSmall.cgPath
        selectAnimation.fillMode = CAMediaTimingFillMode.both
        selectAnimation.isRemovedOnCompletion = false

        let fadeAnim: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = 0.0
        fadeAnim.toValue = 1.0
        CATransaction.setCompletionBlock { [unowned self] in
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = 0.1
            pathAnimation.fromValue = 0
            pathAnimation.toValue = 1

            self.layer.addSublayer(self.tickMarkLayer)
            self.tickMarkLayer.add(pathAnimation, forKey: nil)
        }

        CATransaction.begin()
        checkBoxLayer.add(createGroupAnimation(selectAnimation: selectAnimation, fadeAnimation: fadeAnim), forKey: nil)
        CATransaction.commit()
    }
    func createGroupAnimation(selectAnimation: CABasicAnimation, fadeAnimation: CABasicAnimation) -> CAAnimationGroup {
        let groupAnim: CAAnimationGroup = CAAnimationGroup()
        groupAnim.duration = animationDuration
        groupAnim.repeatCount = 1
        groupAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        groupAnim.animations = [selectAnimation, fadeAnimation]
        return groupAnim
    }

    func uncheckAnimation() {

        let selectAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        selectAnimation.fromValue = checkBoxPathSmall.cgPath
        selectAnimation.toValue = checkBoxPathBig.cgPath
        selectAnimation.fillMode = CAMediaTimingFillMode.both
        selectAnimation.isRemovedOnCompletion = false

        let fadeAnim: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = 1.0
        fadeAnim.toValue = 0.0

        let groupAnim: CAAnimationGroup = CAAnimationGroup()
        groupAnim.duration = animationDuration
        groupAnim.repeatCount = 1
        groupAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        groupAnim.animations = [selectAnimation, fadeAnim]

        CATransaction.setCompletionBlock { [unowned self] in
            self.checkBoxLayer.removeFromSuperlayer()
            self.checkBoxLayer = nil

            self.tickMarkLayer.removeFromSuperlayer()
            self.tickMarkLayer = nil
        }

        CATransaction.begin()
        checkBoxLayer.add(groupAnim, forKey: nil)
        CATransaction.commit()

    }
}
