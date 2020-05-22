//
//  TeamAssembly.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation

protocol TeamAssemblyProtocol {

    func configureView(with viewController: TeamVC)
}

class TeamAssembly: TeamAssemblyProtocol {

    func configureView(with viewController: TeamVC) {
        let viewModelTeam = ViewModelTeam()
        let modelTeam = ModelTeam()
        viewController.viewModelTeam = viewModelTeam
        viewModelTeam.modelTeam = modelTeam

    }
}
