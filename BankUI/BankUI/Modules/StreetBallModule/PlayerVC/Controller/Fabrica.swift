//
//  Fabrica.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class Fabrica {
    func getVC(id: String) -> UIViewController {
        let vc = PlayerVC()
        let model = PlayerModel(playerID: id)
        let viewModel = PlayerVCViewModel(playerModel: model)
        vc.viewModel = viewModel
        return vc
    }
}
