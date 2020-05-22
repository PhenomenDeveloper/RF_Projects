//
//  BottomCardView.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 17.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class BottomCardVC: UIViewController {

    // MARK: - Свойства

    enum CardViewState {
        case normal
        case expanded
    }

    var atmInfo: ATMListModelProtocol?

    private var cardViewState: CardViewState = .normal
    private var cardPaddingTop: CGFloat = 30.0

    // MARK: - UI свойства

    lazy var blurEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blur)
        blurredEffectView.isHidden = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack))
        blurredEffectView.addGestureRecognizer(tapGesture)
        return blurredEffectView
    }()

    ///Карточка на которой располагается вся информация для пользователя
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        return view
    }()

    ///Положение верхней границы карточки представления
    private var topCardViewConstraint: NSLayoutConstraint!

    // MARK: - Инициализация UI

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configureView()

        blurEffect.alpha = 0.0
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragCardView))

        //Чтобы жест перетаскивания срабатывал немедленно
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false

        self.cardView.addGestureRecognizer(panGesture)

        //Во viewDidLoad значения для safeAreaLayoutGuide.layoutFrame.size будут иметь просто размер экрана
        //А нам нужны значения когда safeAreaLayoutGuide уже имеет свои значения, поэтому мы используем данные метод
        topCardViewConstraint = cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.size.height + view.safeAreaInsets.bottom)
        cardView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.height).isActive = true
        topCardViewConstraint.isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showCardAnimation()
    }

    private func configureView() {

        self.view.addSubview(blurEffect)
        blurEffect.setPosition(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        self.view.addSubview(cardView)
        cardView.setPosition(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        cardView.roundCorners(cornerRadius: 20)

        let cardVC = CardViewVC()
        cardVC.atmInfo = atmInfo
        addChild(cardVC)
        cardVC.didMove(toParent: self)
        cardView.addSubview(cardVC.view)
        cardVC.view.setPosition(top: cardView.topAnchor, left: cardView.leftAnchor, bottom: cardView.bottomAnchor, right: cardView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    // MARK: - Анимация

    ///Анимация появления карточки с необходимой информацией
    ///
    /// - Parameters:
    ///     - state: Положение карточки с информацией на экране
    private func showCardAnimation(to state: CardViewState = .normal) {

        //Убеждаемся что перед запуском анимации нету ожидающих изменений для отрисовки view
        self.view.layoutIfNeeded()

        switch state {
        case .normal:
            //Устанавливаем новое положение для карточки
            topCardViewConstraint.constant = (view.safeAreaLayoutGuide.layoutFrame.size.height + view.safeAreaInsets.bottom) / 2
        case .expanded:
            topCardViewConstraint.constant = 30.0
        }

        cardPaddingTop = topCardViewConstraint.constant

        //Задаем анимацию для перемещения карточки вверх и обновляем представления для view
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
            self.blurEffect.alpha = 1
        })

        showCard.startAnimation()
    }

    ///Анимация закрытия карточки
    private func hideCardAnimations() {

        self.view.layoutIfNeeded()

        topCardViewConstraint.constant = view.safeAreaLayoutGuide.layoutFrame.size.height + view.safeAreaInsets.bottom

        let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn) {
            self.view.layoutIfNeeded()
            self.blurEffect.alpha = 0.0
        }

        //Когда анимация закончилась выполняем dismiss
        hideCard.addCompletion { (position) in
            if position == .end {
                //Проверяем что есть куда возвращаться (Есть контроллер который вызвал текущий)
                if self.presentingViewController != nil {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }

        hideCard.startAnimation()
    }

    // MARK: - Обработка действий

    @objc func dragCardView(gesture: UIPanGestureRecognizer) {

        let translation = gesture.translation(in: self.cardView)

        let panSpeed = gesture.velocity(in: self.view)

        switch gesture.state {
        case .began:
            cardPaddingTop = topCardViewConstraint.constant
        case .changed:

            if cardPaddingTop + translation.y > (view.safeAreaLayoutGuide.layoutFrame.size.height + view.safeAreaInsets.bottom) / 3 {

                //Если карточка достаточно высоко, то замедляем ее поднятие
                if topCardViewConstraint.constant < (view.safeAreaLayoutGuide.layoutFrame.size.height + view.safeAreaInsets.bottom) / 2 - 25 {
                    topCardViewConstraint.constant -= setTranslation(value: topCardViewConstraint.constant)
                }
                //Иначе просто меняем ее положение
                else {
                    topCardViewConstraint.constant = cardPaddingTop + translation.y
                }
            }

            blurEffect.alpha = setBackgroundAlphaWithCardTopConstraint(value: topCardViewConstraint.constant)
        case .ended:

            if panSpeed.y > 1000.0 {
                hideCardAnimations()
                return
            }

            //Открывает карточку на весь экран
            if topCardViewConstraint.constant < (view.safeAreaLayoutGuide.layoutFrame.size.height + view.safeAreaInsets.bottom) / 4 {
                showCardAnimation(to: .expanded)
            }
            //Оставляем карточку на изначальном положении
            else if topCardViewConstraint.constant < view.safeAreaLayoutGuide.layoutFrame.size.height - 130 {
                showCardAnimation(to: .normal)
            }
            //Закрывает карточку
            else {
                hideCardAnimations()
            }
        default:
            break
        }
    }

    @objc func goBack() {
        hideCardAnimations()
    }

    // MARK: - Вспомогательные функции

    private func setBackgroundAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
        let maxAlpha: CGFloat = 1

        let maxAlphaPosition = (view.safeAreaLayoutGuide.layoutFrame.size.height + view.safeAreaInsets.bottom) / 2
        let zeroAlphaPosition = view.safeAreaLayoutGuide.layoutFrame.size.height + view.safeAreaInsets.bottom

        //Если карточка находится между нормальным состоянием и полностью открытым
        if value < maxAlphaPosition {
            //ВОзвращаем базовое значение затемнения
            return maxAlpha
        }

        //Если карточка ушла за пределы экрана, то делаем вьюшку полностью прозрачной
        if value > zeroAlphaPosition {
            return 0.0
        }

        //Иначе возвращаем значение прозрачности между 0.0 и 0.8, в зависимости от верхнего положения карточки
        return maxAlpha * 1 - ((value - maxAlphaPosition) / (maxAlphaPosition))
    }

    private func setTranslation(value: CGFloat) -> CGFloat {
        let maxAlpha: CGFloat = 0.9

        let maxAlphaPosition = (view.safeAreaLayoutGuide.layoutFrame.size.height + view.safeAreaInsets.bottom) / 3

        return maxAlpha * -((maxAlphaPosition - value) / (maxAlphaPosition))
    }
}
