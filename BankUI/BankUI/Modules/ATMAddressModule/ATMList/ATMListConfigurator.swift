//
//  ATMListConfigurator.swift
//  BankUI
//
//  Created by Lev Kolesnikov on 21.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

protocol ATMListConfiguratorProtocol {
    func configureView(with viewController: ATMListVC)
}

class ATMListConfigurator: ATMListConfiguratorProtocol {
    func configureView(with viewController: ATMListVC) {
        let presenter = ATMListPresenter(view: viewController)
        let interactor = ATMListInteractor(presenter: presenter)
        let router = ATMListRouter()

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
