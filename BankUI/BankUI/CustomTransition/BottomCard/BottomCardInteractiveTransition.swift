//
//  BottomCardInteractiveTransition.swift
//  BankUI
//
//  Created by Даниил Омельчук on 29.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class BottomCardInteractiveTransition: UIPercentDrivenInteractiveTransition {

    // MARK: - Свойства

    ///Осуществляется ли процесс перехода
    var interactionInProgress = false
    ///Необходимо ли завершить переход
    private var shouldCompleteTransition = false
    ///Контроллер с которым взаимодействует пользователь
    private weak var viewController: UIViewController!
    ///Нижняя граница экрана
    private var bottomPosition: CGFloat = 0
    ///Исходное положение верхней границы контроллера
    var originY: CGFloat = 0

    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragCardView))

    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        prepareGestureRecognizer(in: viewController.view)
        bottomPosition = viewController.view.frame.height - 50
        originY = viewController.view.frame.height
    }

    private func prepareGestureRecognizer(in view: UIView) {
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }

    // MARK: - Обработка жестов

    @objc func dragCardView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view?.superview)

        let panSpeed = gesture.velocity(in: gesture.view?.superview)

        switch gesture.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: {
                print("1234")
            })
        case .changed:
            //Вычисляем процент перемещения
            var percent = translation.y / bottomPosition
            percent = fmin(percent, 1)

            //Если процент меньше 0, значит пользователь дергает карточку вверх
            if percent < 0 {
                //Используем собственную анимацию, так как метод update() работает только с положительными значениями
                viewController.view.frame.origin.y = setTranslation(value: -translation.y)
            } else {
                //                update(percent)
                //Не используем метод update() - так как если мы прервем перетаскивание контроллера, то он вернется на место слишком быстро, а нам это не нужно
                self.viewController.view.frame.origin.y = originY + translation.y

                //Если процент перетаскивания карточки превысил 0.25, то осуществляем переход на предыдущий экран
                shouldCompleteTransition = percent > 0.2

            }
        case .cancelled:
            moveCardToStartPosition()
            interactionInProgress = false
        case .ended:

            //Если дернули слишком быстро, то закрываем карточку
            if panSpeed.y > 1000.0 {
                finish()
                interactionInProgress = false
                return
            }

            if shouldCompleteTransition {
                finish()
            } else {
                moveCardToStartPosition()
            }
            interactionInProgress = false

        default:
            interactionInProgress = false
        }
    }

    ///Анимация возвращаения карточки в исходное положение
    private func moveCardToStartPosition() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, animations: {
            self.viewController.view.frame.origin.y = self.originY
        }, completion: { _ in
            self.cancel()
        })
    }

    ///Считает положения карточки в зависимости от координаты жеста перетаскивания
    private func setTranslation(value: CGFloat) -> CGFloat {
        return value < 70 ? -pow((value / 18), 3) + originY : viewController.view.frame.origin.y
    }
}

extension BottomCardInteractiveTransition: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
