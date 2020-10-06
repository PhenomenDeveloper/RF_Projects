//
//  SceneDelegate.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMaps

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let googleApiKey = "AIzaSyBS2Ol0s1DEcp-Mpxvgf_RiwVqzLEJXvR4"

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        if UserDefaults.standard.value(forKey: "BankUI") != nil {
            let loginVC = LoginVC()
            window.rootViewController = loginVC
        } else {
            let registrationVC = RegistrationMenu()
            window.rootViewController = registrationVC
        }

        self.window = window
        window.makeKeyAndVisible()

        //Получаем путь к папке на данном ПК, где хранится БД Realm

        guard let fileUrl = Realm.Configuration.defaultConfiguration.fileURL else { return }
        print("База данных Realm находится в дирректории - \(fileUrl)")

        GMSServices.provideAPIKey(googleApiKey)
    }
}
