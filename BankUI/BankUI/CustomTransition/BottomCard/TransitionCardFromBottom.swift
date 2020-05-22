//
//  TransitionCardFromBottom.swift
//  BankUI
//
//  Created by Даниил Омельчук on 29.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

protocol BottomCardShowProtocol {
    var contentSize: CGFloat { get }
    func dismissVC()
}

class TransitionCardFromBottom: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Свойства

    ///Blur для экрана с которого пришли
    lazy var blurEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        let blurredEffectView = UIVisualEffectView(effect: blur)
        blurredEffectView.isHidden = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack))
        blurredEffectView.addGestureRecognizer(tapGesture)
        return blurredEffectView
    }()

    ///Время анимации появления
    let presentDuration: TimeInterval
    ///Время анимации исчезновения
    let dismissDuration: TimeInterval
    ///Нужно ли сейчас показать карточку
    public var isPresenting = false
    ///Нужно ли сейчас убрать карточку
    public var isDismissing = false
    ///Ссылка на карточку, чтобы иметь возможность закрыть ее по нажатию на блюр
    private var fromVC: BottomCardShowProtocol?

    ///Объект интерактивного перехода
    var interactionDismiss: BottomCardInteractiveTransition?

    init(presentDuration: TimeInterval, dismissDuration: TimeInterval, interactionController: BottomCardInteractiveTransition?) {
        self.presentDuration = presentDuration
        self.dismissDuration = dismissDuration
        self.interactionDismiss = interactionController
    }

    // MARK: - Анимация перехода

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if isPresenting {
            return presentDuration
        }
        if isDismissing {
            return dismissDuration
        }
        return 0.75
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //Если нужна анимация появления
        if isPresenting {
            guard let toView = transitionContext.view(forKey: .to) else { return }

            let container = transitionContext.containerView
            blurEffect.alpha = 0.0

            container.addSubview(blurEffect)
            blurEffect.fillToSuperView(view: container)
            container.addSubview(toView)

            toView.setPosition(top: nil, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: container.safeAreaLayoutGuide.layoutFrame.size.height)
            toView.roundCorners(cornerRadius: 18)

            container.layoutIfNeeded()
            //Устанвливаем положение верхней границы карточки, ровно под экраном
            toView.frame.origin.y = container.safeAreaLayoutGuide.layoutFrame.size.height + container.safeAreaInsets.bottom + container.safeAreaInsets.top

            if let toVC = transitionContext.viewController(forKey: .to) as? BottomCardShowProtocol {
                self.fromVC = toVC
                //toVC.contentSize - Высота представляемого контроллера
                presentAnimation(transitionContext: transitionContext, animatedView: toView, endPoint: toVC.contentSize)
            } else {
                presentAnimation(transitionContext: transitionContext, animatedView: toView, endPoint: (container.safeAreaLayoutGuide.layoutFrame.size.height + container.safeAreaInsets.bottom) / 2)
            }
        }
        //Если нужна анимация исчезновения
        if isDismissing {
            guard let fromView = transitionContext.view(forKey: .from) else { return }

            let container = transitionContext.containerView
            blurEffect.alpha = 1.0
            if let fromVC = transitionContext.viewController(forKey: .from) as? BottomCardShowProtocol {
                //Считаем, где находится верхняя граница карточки (высота всего экрана - высота отображаемой карточки)
                fromView.frame.origin.y = container.safeAreaLayoutGuide.layoutFrame.size.height + container.safeAreaInsets.bottom + container.safeAreaInsets.top - fromVC.contentSize
                dismissAnimation(transitionContext: transitionContext, animatedView: fromView, endPoint: fromVC.contentSize)
            } else {
                fromView.frame.origin.y = container.safeAreaLayoutGuide.layoutFrame.size.height + container.safeAreaInsets.bottom + container.safeAreaInsets.top
                dismissAnimation(transitionContext: transitionContext, animatedView: fromView, endPoint: (container.safeAreaLayoutGuide.layoutFrame.size.height + container.safeAreaInsets.bottom) / 2)
            }
        }
    }

    /// Анимация представления карточки на экране
    ///
    /// - Parameters:
    ///     - transitionContext: Контекст в котором происходит переход
    ///     - animatedView: UIView, который необходимо анимировать
    ///     - endPoint: Конечная точка положения верхней границы `animatedView`
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning, animatedView: UIView, endPoint: CGFloat) {
        UIView.animate(withDuration: presentDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
            animatedView.frame.origin.y -= endPoint
            self.blurEffect.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    /// Анимация исчезновения карточки с экрана
    ///
    /// - Parameters:
    ///     - transitionContext: Контекст в котором происходит переход
    ///     - animatedView: UIView, который необходимо анимировать
    ///     - endPoint: Конечная точка положения верхней границы `animatedView`
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning, animatedView: UIView, endPoint: CGFloat) {
        UIView.animate(withDuration: dismissDuration, animations: {
            animatedView.frame.origin.y += endPoint
            self.blurEffect.alpha = 0.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    //Если пользователь нажмет на blur, карточка скроется с экрана
    @objc func goBack() {
        self.fromVC?.dismissVC()
    }
}
