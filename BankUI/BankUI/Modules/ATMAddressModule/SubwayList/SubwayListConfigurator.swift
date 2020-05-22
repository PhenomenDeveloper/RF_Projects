//
//  SubwayListConfigurator.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

protocol SubwayListConfiguratorProtocol {
    func configureView(with viewController: SubwayListVC)
}

class SubwayListConfigurator: SubwayListConfiguratorProtocol {
    func configureView(with viewController: SubwayListVC) {
        let presenter = SubwayListPresenter(view: viewController)
        let interactor = SubwayListInteractor(presenter: presenter)
        let router = SubwayListRouter()

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
