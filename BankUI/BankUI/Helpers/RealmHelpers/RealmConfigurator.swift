//
//  RealmConfigurator.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import RealmSwift

enum RealmConfigurations: String {
    case transactionsConfiguration = "Transactions.realm"
    case AtmConfiguration = "ATM.realm"
    case subwayConfiguration = "Subways.realm"
}

final class RealmConfigurator {

    static func getRealmConfiguration(configurationName: RealmConfigurations) -> Realm.Configuration {
        var config = Realm.Configuration()
        guard let fileUrl = config.fileURL else { return config }
        config.fileURL = fileUrl.deletingLastPathComponent().appendingPathComponent(configurationName.rawValue)
        return config
    }
}
