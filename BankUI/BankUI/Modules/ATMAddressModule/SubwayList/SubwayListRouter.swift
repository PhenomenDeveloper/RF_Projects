//
//  SubwayListRouter.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 24.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

protocol SubwayListRouterProtocol: class {
    func showAtmsWithChoosenSubway(with subway: SubwayListModelProtocol, from subwayVC: SubwayListVCProtocol)
}

class SubwayListRouter: SubwayListRouterProtocol {

    func showAtmsWithChoosenSubway(with subway: SubwayListModelProtocol, from subwayVC: SubwayListVCProtocol) {
        let atmsList = ATMListVC()
        let navVC = subwayVC.getParentNavigationVC()
        guard let navigationVC = navVC else { return }
        navigationVC.pushViewController(atmsList, animated: true)
        atmsList.loadAtmsData(dataType: .sybwaysAtms(subway: subway))
    }
}
