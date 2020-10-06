//
//  LoginVC.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginVC: UIViewController {

    ///view с уведомлением
    let notificationView: CustomNotificationView = {
        let view = CustomNotificationView()
        view.containerView.backgroundColor = #colorLiteral(red: 0.8262984157, green: 0.09207040817, blue: 0.05776014179, alpha: 1)
        return view
    }()

    ///Контекст для биометрики
    let laContext = LAContext()
    var error: NSError?

    let numpad = LoginNumPad()

    let bottomCardPresentor = TransitionCardFromBottom(presentDuration: 0.6, dismissDuration: 0.25, interactionController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewComponents()
        authorization()
    }

    lazy var addressButton: UIButton = {
        let address = UIButton(type: .system)
        let image = UIImage(named: "mapMarker")?.withRenderingMode(.alwaysTemplate)

        address.backgroundColor = .clear
        address.setTitle("  Адреса", for: .normal)
        address.setImage(image, for: .normal)
        address.tintColor = .white
        address.setTitleColor(.white, for: .normal)
        address.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        address.clipsToBounds = true
        address.isUserInteractionEnabled = true
        address.addTarget(self, action: #selector(addressButtonTaped), for: .touchUpInside)

        return address
    }()

    lazy var supportButton: UIButton = {
           let support = UIButton(type: .system)
           let image = UIImage(named: "support")?.withRenderingMode(.alwaysTemplate)

           support.backgroundColor = .clear
           support.setTitle("  Поддержка", for: .normal)
           support.setImage(image, for: .normal)
           support.tintColor = .white
           support.setTitleColor(.white, for: .normal)
        support.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
           support.clipsToBounds = true
           support.isUserInteractionEnabled = true
           support.addTarget(self, action: #selector(supportButtonTaped), for: .touchUpInside)
           return support
       }()

    @objc func addressButtonTaped() {
        let mapVC = AtmsMapVC()
        mapVC.exitButton.isHidden = false
        mapVC.modalPresentationStyle = .fullScreen

        self.present(mapVC, animated: true, completion: nil)
    }

    @objc func supportButtonTaped() {
//        Crashlytics.sharedInstance().setUserName("12345")
//        Crashlytics.sharedInstance().crash()
        let aboutVC = AboutVC()
        aboutVC.transitioningDelegate = self
        aboutVC.modalPresentationStyle = .custom
        bottomCardPresentor.interactionDismiss = BottomCardInteractiveTransition(viewController: aboutVC)
        self.present(aboutVC, animated: true, completion: nil)
    }

    private func setViewComponents() {
        let gradientView = BackgroundGradient()
        gradientView.startColor = ThemeManager.Color.startGradientColor
        gradientView.endColor = ThemeManager.Color.endGradientColor

        numpad.delegate = self
        numpad.delegateBio = self

        self.view.addSubview(gradientView)
        gradientView.setPosition(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        self.view.addSubview(numpad)
        numpad.setPosition(top: nil, left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 18, paddingBottom: 80, paddingRight: 18, width: 0, height: 380)
        numpad.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.view.addSubview(notificationView)

        notificationView.setPosition(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 50, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 45)
        notificationView.isHidden = true

        self.view.addSubview(addressButton)
        addressButton.setPosition(top: nil, left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 40, paddingBottom: 16, paddingRight: 0, width: 0, height: 0)

        self.view.addSubview(supportButton)
        supportButton.setPosition(top: nil, left: nil, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 40, width: 0, height: 0)

    }
}

extension LoginVC: AuthorizationDelegate {

    ///Функция авторизации по биометрии
    func authorization() {

        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics

        if laContext.canEvaluatePolicy(biometricsPolicy, error: &error) {

            if let laError = error {
                print("laError - \(laError)")
                return
            }

            var localizedReason = "Unlock device"
            if #available(iOS 11.0, *) {
                if laContext.biometryType == LABiometryType.faceID {
                    numpad.verificationButton.image = UIImage(named: "faceId")
                    localizedReason = "Unlock using Face ID"
                    print("FaceId support")
                } else if laContext.biometryType == LABiometryType.touchID {
                    numpad.verificationButton.image = UIImage(named: "touchId")
                    localizedReason = "Unlock using Touch ID"
                    print("TouchId support")
                } else {
                    print("No Biometric support")
                }
            } else {
//                Более ранние версии
            }

            laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in

                DispatchQueue.main.async(execute: {

                    if let laError = error {
                        print("laError - \(laError)")
                    } else {
                        if isSuccess {
                            print("success")
                            self.numpad.confirmPinAnimation()
                            self.goToMainVC()
                        } else {
                            print("failure")
                        }
                    }

                })
            })
        }

    }
}

extension LoginVC: GoToMainVC {
    func goToMainVC() {

        let dataFetcher = NetworkDataFetcher(networking: NetworkService())

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dataFetcher.getNetworkUserData { [unowned self] (model) in
                guard let user = model else {
                    self.notificationView.isHidden = false
                    self.notificationView.startNotification()

                    self.numpad.clearDots()
                    print("Ошибка получения токена")
                    return
                }
                let bankBaseVC = BankBaseVC()
                let userNetwork = NetworkUser(name: user.resourceOwner.firstName + " " + String(user.resourceOwner.lastName.first!) + ".",
                                              mobilePhone: user.resourceOwner.mobilePhone,
                                              email: user.resourceOwner.email)
                NetworkUser.userToken = user.accessToken
                bankBaseVC.moreVC.headerVC.networkUserData = userNetwork
                bankBaseVC.moreVC.headerVC.setUserData()
                bankBaseVC.modalPresentationStyle = .fullScreen
                self.present(bankBaseVC, animated: true) {
                    self.numpad.clearDots()
                }
            }
        }
    }
}

extension LoginVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        bottomCardPresentor.isPresenting = true
        return bottomCardPresentor
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        bottomCardPresentor.isPresenting = false
        bottomCardPresentor.isDismissing = true
        return bottomCardPresentor
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? TransitionCardFromBottom,
          let interactionController = animator.interactionDismiss,
          interactionController.interactionInProgress
          else {
            return nil
        }
        return interactionController
    }
}
