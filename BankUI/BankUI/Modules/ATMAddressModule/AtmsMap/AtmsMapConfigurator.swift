//
//  AtmsMapConfigurator.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 11.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

protocol AtmsMapConfiguratorProtocol {
    func configureView(with viewController: AtmsMapVC)
}

class AtmsMapConfigurator: AtmsMapConfiguratorProtocol {
    func configureView(with viewController: AtmsMapVC) {
        let presenter = AtmsMapPresenter(view: viewController)
        let interactor = AtmsMapInteractor(presenter: presenter)
        let router = AtmsMapRouter()

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
