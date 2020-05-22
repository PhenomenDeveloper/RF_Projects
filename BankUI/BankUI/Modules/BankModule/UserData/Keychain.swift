//
//  KeyChain3.swift
//  BankUI
//
//  Created by MANVELYAN Gevorg on 15.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import Foundation

class Keychain {
    static var service = "Bank"
    static var passwordAccount = "Password"
    static var pinAccount = "Pin"
    static var status: OSStatus = -1

    class func passwordQuery(service: String, account: String) -> [String: Any] {
        let dictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ] as [String: Any]

        return dictionary
    }

    ///Сохранение пароля в Keychain
    class func setPassword(_ password: String, service: String, account: String) {
//        var status : OSStatus = -1
        if !(service.isEmpty) && !(account.isEmpty) {
            deletePassword(service: service, account: account)

            if !password.isEmpty {
                var dictionary = passwordQuery(service: service, account: account)
                let dataFromString = password.data(using: String.Encoding.utf8, allowLossyConversion: false)
                dictionary[kSecValueData as String] = dataFromString
                status = SecItemAdd(dictionary as CFDictionary, nil)
            }
        }
        return
    }
    ///Удаление пароля из Keychain
    class func deletePassword(service: String, account: String) {

        if !(service.isEmpty) && !(account.isEmpty) {
            let dictionary = passwordQuery(service: service, account: account)
            status = SecItemDelete(dictionary as CFDictionary)
        }
    }

    ///Чтение пароля из Keychain
    class func password(service: String, account: String) -> String {
        var status: OSStatus = -1
        var resultString = ""
        if !(service.isEmpty) && !(account.isEmpty) {
            var passwordData: AnyObject?
            var dictionary = passwordQuery(service: service, account: account)
            dictionary[kSecReturnData as String] = kCFBooleanTrue
            dictionary[kSecMatchLimit as String] = kSecMatchLimitOne
            status = SecItemCopyMatching(dictionary as CFDictionary, &passwordData)

            if status == errSecSuccess {
                if let retrievedData = passwordData as? Data {
                    resultString = String(data: retrievedData, encoding: String.Encoding.utf8)!
                }
            }
        }
        return resultString
    }

    ///Проверка правильности ПИН
    class func pinConfirm(pin: String) -> Bool {
        let pinCode = Keychain.password(service: Keychain.service, account: Keychain.pinAccount)

        if pin == pinCode {
            return true
        } else {
            return false
        }
    }
}
