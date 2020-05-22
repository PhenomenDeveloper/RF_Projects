//
//  CalendarConfigurator.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation

protocol CalendarConfiguratorProtocol: class {
    func configureView(with viewController: CalendarVC)
}

class CalendarConfigurator: CalendarConfiguratorProtocol {

    func configureView(with viewController: CalendarVC) {
        let presenter = CalendarPresenter(view: viewController)
        let interactor = CalendarInteractor(presenter: presenter)
        let router = CalendarRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
