//
//  UserData.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import Foundation

struct UserData {

    static let (emailKey, nameKey, telephoneKey, filterKey) = ("email", "name", "telephone", "filter")
    static let userSessionKey = "BankUI"
    private static let userDefault = UserDefaults.standard

    struct UserDetails {
        let email: String
        let name: String
        let telephone: String
        let selectedFilters: [Bool]

        init(_ json: [String: Any]) {
            self.email = json[emailKey] as? String ?? ""
            self.name = json[nameKey] as? String ?? ""
            self.telephone = json[telephoneKey] as? String ?? ""
            self.selectedFilters = json[filterKey] as? [Bool] ?? [true, true, true]
        }
    }

    ///Сохранение в User Defaults
    static func save(_ email: String, name: String, telephone: String) {

        userDefault.set([emailKey: email, nameKey: name, telephoneKey: telephone, filterKey: [true, true, true]],
                        forKey: userSessionKey)
    }

    static func saveFilters(filters: [Bool]) {
        userDefault.set([emailKey: UserData.getUserInfo().email, nameKey: UserData.getUserInfo().name, telephoneKey: UserData.getUserInfo().telephone, filterKey: filters],
                        forKey: userSessionKey)
    }

    static func saveNewData(_ email: String, telephone: String) {
        userDefault.set([emailKey: email, nameKey: UserData.getUserInfo().name, telephoneKey: telephone, filterKey: UserData.getFilters()],
                        forKey: userSessionKey)
    }

    static func getUserInfo() -> UserDetails {
        return UserDetails((userDefault.value(forKey: userSessionKey) as? [String: Any]) ?? [:])
    }

    static func getFilters() -> [Bool] {
        let value = UserDetails((userDefault.value(forKey: userSessionKey) as? [String: Any]) ?? [:])
        return value.selectedFilters
    }

    static func clearUserData() {
        userDefault.removeObject(forKey: userSessionKey)
    }
}
