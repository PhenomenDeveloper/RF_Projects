//
//  CalendarRouter.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

protocol CalendarRouterProtocol: class {

    func goToCommandVC(with teamId: String)
}

class CalendarRouter: CalendarRouterProtocol {

    weak var viewController: CalendarVCProtocol!

    init(viewController: CalendarVCProtocol) {
        self.viewController = viewController
    }

    func goToCommandVC(with teamId: String) {
        let teamVC = TeamVC()
        teamVC.teamID = teamId
        self.viewController.navigationController?.pushViewController(teamVC, animated: true)
    }
}
