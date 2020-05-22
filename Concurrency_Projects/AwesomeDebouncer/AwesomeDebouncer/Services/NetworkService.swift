//
//  NetworkService.swift
//  AwesomeDebouncer
//
//  Created by Lev Kolesnikov on 29.12.2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation

protocol Netwoking {
    func getSuggestionsData(searchWord: String, path: String, completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Netwoking {
    
    ///Получает историю транзакций из сети
    ///
    /// - Parameters:
    ///     - searchWord: Слово по которому осуществляется запрос в сеть
    ///     - path: Путь запроса, который меняется в зависимости от выбора пользователя на экране
    ///     - completion: Блок кода который выполнится на главном потоке
    func getSuggestionsData(searchWord: String, path: String, completion: @escaping (Data?, Error?) -> Void) {
        
        let body = self.prepareBody(searchWord: searchWord)
        let url = self.url(from: path)
        
        let request = setupRequest(url: url, body: body)
        let task = createDataTask(from: request, completion: completion)
        
        task.resume()
    }
    
    /// Подготовка тела запроса
    ///
    /// - Parameters:
    ///     -  searchWord: Слово по которому осуществляется запрос в сеть
    ///
    /// - Returns:
    ///     Возвращает готовое тело для дальнейшей подстановки в запрос
    private func prepareBody(searchWord: String?) -> [String: Any] {
        var body = [String: Any]()
        body["query"] = searchWord
        body["count"] = String(1)
        return body
    }
    
    /// Создание и подготовка запроса
    ///
    /// - Parameters:
    ///     -  url: Адрес по которому будет создан запрос
    ///     -  body: Тело запроса
    ///
    /// - Returns:
    ///     Возвращает готовый запрос
    private func setupRequest(url: URL, body: [String : Any]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print(error.localizedDescription)
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(APINetwork.token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    ///Формирует необходимую задачу для запроса данных из сети
    ///
    /// - Parameters:
    ///     - request: Сформированный запрос в сеть
    ///     - completion: Блок кода который выполнится на главном потоке
    /// - Returns:
    ///     Возвращает сконфигурированную задачу для получения данных из сети
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {        return URLSession.shared.dataTask(with: request) { (data, responser, error) in
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
    private func url(from path: String, params: [String:String] = [:]) -> URL {
        var components = URLComponents()
        
        components.scheme = APINetwork.scheme
        components.host = APINetwork.host
        components.path = path
        if params.count > 0 {
            components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        }
        
        return components.url!
    }
}
