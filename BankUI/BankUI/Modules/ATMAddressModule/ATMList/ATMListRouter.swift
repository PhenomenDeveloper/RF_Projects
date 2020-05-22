//
//  ATMListRouter.swift
//  BankUI
//
//  Created by Lev Kolesnikov on 21.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

protocol ATMListRouterProtocol: class {

    func showBottomCard(with atmInfo: ATMListModelProtocol, from atmVC: ATMListVCProtocol)
}

class ATMListRouter: ATMListRouterProtocol {

    func showBottomCard(with atmInfo: ATMListModelProtocol, from atmVC: ATMListVCProtocol) {
        let card = CardViewVC()
        card.modalPresentationStyle = .custom
        card.atmInfo = atmInfo
        let vc = atmVC as? ATMListVC
        card.transitioningDelegate = vc
        vc?.bottomCardPresentor.interactionDismiss = BottomCardInteractiveTransition(viewController: card)
        OperationQueue.main.addOperation {
            atmVC.present(card, animated: true, completion: nil)
        }
    }
}
