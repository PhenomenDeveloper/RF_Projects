//
//  SignatureView.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 06.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

enum SignatureAnimationDirection {
    case forward
    case reverse
}

class SignatureView: UIView {

    // MARK: - Свойства
    ///Цвет линии рисования
    private var strokeColor = UIColor.white //UIColor(red: 255/255, green: 219/255, blue: 0, alpha: 1)
    ///Ширина линии рисования
    private var strokeWidth: Float = 2
    ///Массив содержащий координаты нарисованной линии
    private var lines = [Line]()
    ///Массив который содержит последнюю созданную пользователем подпись
    private var previousLines = [Line]()
    ///Слой, который содержит в себе анимацию отрисовки подписи
    private var drawingLayer: CAShapeLayer = CAShapeLayer()
    ///Идет ли анимация отрисовки подписи
    private var isAnimated = false
    ///Остановлена ли анимация
    private var isPaused = false

    // MARK: - Рисование

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Если точки которые нарисовал пользователь пустые, и он начал рисовать заново, то стираем контент который есть
        if lines.count == 0 {
            clear()
        }
        lines.append(Line(strokeWidth: strokeWidth, color: strokeColor, points: []))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            for (i, p) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            context.strokePath()
        }
    }

    // MARK: - Анимация

    ///Очищает содержимое
    func clear() {
        //Удаляем слой анимации, чтобы очистить поверхность для рисования
        drawingLayer.removeFromSuperlayer()
        //Если в этом массиве есть точки, то нужно сохранить эту подпись в массив, иначе это означает что пользователь просто играется с анимацией подписи
        if lines.count > 0 {
            previousLines = lines
        }
        //Удаляем точки из массива, чтобы очистить поле для отрисовки анимации
        lines.removeAll()
        setNeedsDisplay()
    }

    ///Отрисовывает подпись с начала и до конца
    func playSignature(direction: SignatureAnimationDirection) {

        let path = UIBezierPath()
        //Очищаем поле для анимации
        clear()

        //Отрисовку проводит по точкам, которые хранятся в массиве previousLines
        guard let firstPoint = previousLines.first?.points.first else {return}
        path.move(to: firstPoint)

        for i in 0..<previousLines.count {
            for j in 0..<previousLines[i].points.count {
                if j == 0 {
                    path.move(to: previousLines[i].points[j])
                } else {
                    path.addLine(to: previousLines[i].points[j])
                }
            }
        }

        CATransaction.begin()

        isAnimated = true

        drawingLayer = CAShapeLayer()
        drawingLayer.path = path.cgPath
        drawingLayer.strokeEnd = 0
        drawingLayer.lineWidth = CGFloat(strokeWidth)
        drawingLayer.strokeColor = strokeColor.cgColor
        drawingLayer.fillColor = UIColor.clear.cgColor

        self.layer.addSublayer(drawingLayer)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        switch direction {
        case .forward:
            animation.fromValue = 0
            animation.toValue = 1
        case .reverse:
            animation.fromValue = 1
            animation.toValue = 0
        }

        animation.duration = 3
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false

        CATransaction.setCompletionBlock {[weak self] in
            self?.isAnimated = false
        }

        drawingLayer.add(animation, forKey: "signatureAnimation")

        CATransaction.commit()
    }

    ///Ставит анимацию на паузу
    func pauseSignature() {
        isPaused = true
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    ///Продолжает анимацию с места остановки
    func resumeAnimation() {
        isPaused = false
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }

    func isSignatureAnimated() -> Bool {
        return isAnimated
    }

    func isSignaturePaused() -> Bool {
        return isPaused
    }

    func getUsersSignature() -> [Line] {
        if previousLines.count == 0 {
            return lines
        } else {
            return previousLines
        }
    }
}
