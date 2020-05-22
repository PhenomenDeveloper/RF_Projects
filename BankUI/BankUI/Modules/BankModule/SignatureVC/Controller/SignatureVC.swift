//
//  SignatureVC.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 06.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

protocol SetUsersSignaturePathProtocol: class {
    func setUserSignaturePath(path: [Line])
}

class SignatureVC: UIViewController {

    // MARK: - UI элементы

    private let signatureView: SignatureView = {
        let signature = SignatureView()
        signature.backgroundColor = #colorLiteral(red: 0.2309085436, green: 0.2398462948, blue: 0.2547333062, alpha: 1)
        signature.clipsToBounds = true
        signature.layer.cornerRadius = 20
        return signature
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "play_pause"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.2309085436, green: 0.2398462948, blue: 0.2547333062, alpha: 1)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        button.addTarget(self, action: #selector(playSignature), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var reverseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "rewind"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        button.tintColor = #colorLiteral(red: 0.2309085436, green: 0.2398462948, blue: 0.2547333062, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(reverseSignature), for: .touchUpInside)
        return button
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "trash"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        button.tintColor = #colorLiteral(red: 0.2309085436, green: 0.2398462948, blue: 0.2547333062, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(clearSignature), for: .touchUpInside)
        return button
    }()

    private lazy var saveButton: UIButton = {
        let regButton = UIButton(type: .system)
        regButton.setTitleColor(.white, for: .normal)
        regButton.setTitle("Сохранить", for: .normal)
        regButton.backgroundColor = #colorLiteral(red: 0.2309085436, green: 0.2398462948, blue: 0.2547333062, alpha: 1)
        regButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        regButton.layer.cornerRadius = 8
        regButton.clipsToBounds = true
        regButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return regButton
    }()

    private var saveTitle: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2309085436, green: 0.2398462948, blue: 0.2547333062, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.text = "Идет сохранение..."
        label.alpha = 0
        return label
    }()

    // MARK: - Свойства Анимации
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    weak var delegate: SetUsersSignaturePathProtocol?

    var saveIndicatorView: UIView = UIView()

    var check: Checkmark = {
        let check = Checkmark(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        check.animated = true
        check.animatedLayerColor = #colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)
        check.initialLayerColor = #colorLiteral(red: 1, green: 0.8588235294, blue: 0, alpha: 1)
        check.alpha = 0

        return check
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setCanvas()
    }

    private func setCanvas() {

        self.view.addSubview(signatureView)
        signatureView.setPosition(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: view.layer.bounds.height / 3)

        self.view.addSubview(playButton)
        playButton.setPosition(top: signatureView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 40)
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        self.view.addSubview(saveTitle)

        saveTitle.setPosition(top: signatureView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        saveTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        self.view.addSubview(reverseButton)
        reverseButton.setPosition(top: nil, left: nil, bottom: nil, right: playButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 35, height: 35)
        reverseButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true

        self.view.addSubview(clearButton)
        clearButton.setPosition(top: nil, left: playButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 35, height: 35)
        clearButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true

        self.view.addSubview(saveButton)
        saveButton.setPosition(top: playButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 10, paddingBottom: 12, paddingRight: 10, width: 0, height: 50)
    }

    // MARK: - Методы анимации

    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor, lineWidth: CGFloat ) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = lineWidth
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = CGPoint(x: saveIndicatorView.layer.bounds.width / 2, y: saveIndicatorView.layer.bounds.height / 2)
        return layer
    }

    private func setupCircleLayers() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .clear, lineWidth: 7)
        saveIndicatorView.layer.addSublayer(pulsatingLayer)

        let trackLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .clear, lineWidth: 5)
        saveIndicatorView.layer.addSublayer(trackLayer)

        shapeLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .clear, lineWidth: 3)

        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        saveIndicatorView.layer.addSublayer(shapeLayer)

    }

    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")

        animation.toValue = 1.12
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        pulsatingLayer.add(animation, forKey: "pulsing")
    }

    private func animateStrokeColor(toValue: UIColor) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeColor")

        animation.toValue = toValue.cgColor
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false

        return animation
    }

    private func startAnimating() {
        self.check.alpha = 0
        shapeLayer.strokeEnd = 0
        self.pulsatingLayer.removeAllAnimations()

        shapeLayer.add(animateStrokeColor(toValue: #colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)), forKey: "shapeColor")
        pulsatingLayer.add(animateStrokeColor(toValue: #colorLiteral(red: 0.8956105113, green: 0.8957609534, blue: 0.8955907226, alpha: 1)), forKey: "pulsColor")

        self.saveTitle.alpha = 0.4
        UIView.animate(withDuration: 0.45, delay: 0, options: [.repeat, .curveEaseInOut, .autoreverse], animations: {
            self.saveTitle.alpha = 1
        }, completion: nil)

        animatePulsatingLayer()
    }

    private func animateCircle() {
        CATransaction.begin()
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

        basicAnimation.toValue = 1

        basicAnimation.duration = 2.0

        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false

        CATransaction.setCompletionBlock {
            self.saveTitle.layer.removeAllAnimations()
            UIView.animate(withDuration: 0.8, animations: {
                self.check.alpha = 1
                self.check.animate()
                self.saveTitle.text = "Сохранено"
            }, completion: { _ in
                self.dismiss(animated: true) { [weak self] in
                    guard let delegate = self?.delegate, let this = self else { return }
                    delegate.setUserSignaturePath(path: this.signatureView.getUsersSignature())
                }
            })
        }

        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        CATransaction.commit()
    }

    private func playSaveAnimation() {
        view.addSubview(saveIndicatorView)

        saveIndicatorView.setPosition(top: nil, left: view.leftAnchor, bottom: signatureView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 60, paddingRight: 50, width: 0, height: 100)

        saveIndicatorView.addSubview(check)
        view.layoutSubviews()

        check.centerXAnchor.constraint(equalTo: saveIndicatorView.centerXAnchor).isActive = true
        check.centerYAnchor.constraint(equalTo: saveIndicatorView.centerYAnchor).isActive = true

        self.setupCircleLayers()
        startAnimating()

        animateCircle()
    }

    // MARK: - Обработка нажатия кнопок

    @objc func playSignature() {
        if !signatureView.isSignatureAnimated() {
            signatureView.playSignature(direction: .forward)
        } else {
            signatureView.isSignaturePaused() ? signatureView.resumeAnimation() : signatureView.pauseSignature()
        }
    }

    @objc func reverseSignature() {
        if !signatureView.isSignatureAnimated() {
            signatureView.playSignature(direction: .reverse)
        }
    }

    @objc func clearSignature() {
        signatureView.clear()
    }

    @objc func saveButtonTapped() {
        UIView.animate(withDuration: 0.5, animations: {
            self.signatureView.alpha = 0
            self.playButton.alpha = 0
            self.reverseButton.alpha = 0
            self.clearButton.alpha = 0
            self.saveButton.alpha = 0
        }, completion: { _ in
            self.playSaveAnimation()
        })
    }
}

extension SignatureVC: BottomCardShowProtocol {

    ///Размер отображаемой части
    var contentSize: CGFloat {
        return 160 + signatureView.frame.height
    }

    ///Закрытие контроллера
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
