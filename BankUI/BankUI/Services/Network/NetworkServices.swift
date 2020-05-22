//
//  NetworkServices.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 17/12/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation

protocol Netwoking {
    func getHistoryData(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
    func getHistoryDataWithLogo(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
    func getNetworkUserData(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
    func getLogoData(imagePath: String, completion: @escaping (Data?, Error?) -> Void)
    func getATMsAndSubwaysData(path: String, completion: @escaping (Data?, Error?) -> Void)
}

enum HostType: String, CaseIterable {
    case heroku
    case raiffeisen

    var hostName: String {
        switch self {
        case .heroku:
            return APINetwork.host
        case .raiffeisen:
            return APINetwork.logoHost
        }
    }
}

final class NetworkService: Netwoking {
    ///Получает историю транзакций из сети
    ///
    /// - Parameters:
    ///     - path: Адрес по которому осуществляется запрос в сеть
    ///     - params: Параметры для запроса по сети
    ///     - completion: Блок кода который выполнится на главном потоке
    func getHistoryData(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        let url = self.url(host: .heroku, from: path, params: params)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.addValue("Bearer \(NetworkUser.userToken)", forHTTPHeaderField: "Authorization")

        let task = createDataTask(from: request, completion: completion)

        task.resume()
    }

    ///Получает историю транзакций из сети с логотипом
    ///
    /// - Parameters:
    ///     - path: Адрес по которому осуществляется запрос в сеть
    ///     - params: Параметры для запроса по сети
    ///     - completion: Блок кода который выполнится на главном потоке
    func getHistoryDataWithLogo(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        let url = self.url(host: .heroku, from: path, params: params)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = createDataTask(from: request, completion: completion)

        task.resume()
    }

    ///Получает токен авторизации для пользователя из сети
    ///
    /// - Parameters:
    ///     - path: Адрес по которому осуществляется запрос в сеть
    ///     - params: Параметры для запроса по сети
    ///     - completion: Блок кода который выполнится на главном потоке
    func getNetworkUserData(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        let url = self.url(host: .heroku, from: path)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }

        let task = createDataTask(from: request, completion: completion)

        task.resume()
    }

    /// Получение логотипов для транзакции
    ///
    /// - Parameters:
    ///     - imagePath: Адрес по которому осуществляется запрос в сеть для получения логотипа
    ///     - completion: Блок кода который выполнится на главном потоке
    func getLogoData(imagePath: String, completion: @escaping (Data?, Error?) -> Void) {
        let url = self.url(host: .raiffeisen, from: imagePath)
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = createDataTask(from: request, completion: completion)

        task.resume()
    }

    /// Получение данных о банкоматах и метро
    ///
    /// - Parameters:
    ///     - path: Адрес по которому осуществляется запрос в сеть
    ///     - completion: Блок кода который выполнится на главном потоке
    func getATMsAndSubwaysData(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let url = self.url(host: .raiffeisen, from: path)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    ///Формирует необходимую задачу для запроса данных из сети
    ///
    /// - Parameters:
    ///     - request: Сформированный запрос в сеть
    ///     - completion: Блок кода который выполнится на главном потоке
    /// - Returns:
    ///     Возвращает сконфигурированную задачу для получения данных из сети
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {        return URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }

    ///Формирует необходимую URL строку в соответствии с заданными параметрами
    ///
    /// - Parameters:
    ///     - path: Путь запроса
    ///     - params: Параметры запроса для URL строки
    /// - Returns:
    ///     Возвращает сформированную URL
    private func url(host: HostType, from path: String, params: [String: String] = [:]) -> URL {
        var components = URLComponents()

        components.scheme = APINetwork.scheme
        components.host = host.hostName
        components.path = path
        if params.count > 0 {
            components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        }

        return components.url!
    }
}
