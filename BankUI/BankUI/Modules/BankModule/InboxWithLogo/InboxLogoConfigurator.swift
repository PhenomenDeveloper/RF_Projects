//
//  InboxLogoConfigurator.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 15.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

protocol InboxLogoConfiguratorProtocol {
    func configureView(with viewController: InboxLogoVC)
}

class InboxLogoConfigurator: InboxLogoConfiguratorProtocol {

    func configureView(with viewController: InboxLogoVC) {
        let presenter = InboxLogoPresenter(view: viewController)
        let interactor = InboxLogoInteractor(presenter: presenter)

        viewController.presenter = presenter
        presenter.interactor = interactor
    }
}
