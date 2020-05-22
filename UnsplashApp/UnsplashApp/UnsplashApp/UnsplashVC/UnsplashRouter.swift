//
//  UnsplashRouter.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import Foundation

protocol UnsplashRouterProtocol: class {
    
    
}

class UnsplashRouter: UnsplashRouterProtocol {
    
    weak var viewController: UnsplashVCProtocol!
    
    init(viewController: UnsplashVCProtocol) {
        self.viewController = viewController
    }
}
