//
//  UnsplashConfigurator.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import Foundation

protocol UnsplashConfiguratorProtocol: class {
    func configureView(with viewController: UnsplashVC)
}

class UnsplashConfigurator: UnsplashConfiguratorProtocol {
    
    func configureView(with viewController: UnsplashVC) {
        let presenter = UnsplashPresenter(view: viewController)
        let interactor = UnsplashInteractor(presenter: presenter)
        let router = UnsplashRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
