//
//  NetworkService.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import Foundation

class NetworkService {

    
    /// Построение запроса данных по URL
    ///
    /// - Parameters:
    ///     -  searchTerm: поисковый запрос
    func request(searchTerm: String, page: Int, completion: @escaping (Data?, Error?) -> Void) {
        
        
        let parameters = self.prepareParameters(searchTerm: searchTerm, page: page)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
//  Заполнение необходимого хэдера для получения доступа к запросам
    
    /// Заполнение необходимого хэдера для получения доступа к запросам
    ///
    /// - Returns:
    ///     возвращает заполненный хэдер
    private func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID 6a5917b4c5eae9fd55fd558cff0a158dbe6b521de28c017800de6e402407046c"
        return headers
    }
     
    /// Подготовка параметров запроса
    ///
    /// - Parameters:
    ///     -  param: Параметр
    ///
    private func prepareParameters(searchTerm: String?, page: Int) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(page)
        parameters["per_page"] = String(10)
        return parameters
    }
    
    /// Конфигурация URL
    ///
    /// - Parameters:
    ///     -  param: Параметр
    /// - Returns:
    ///     составленный URL
    private func url(params: [String : String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
//        Конвертирование параметров в вид для URL строки
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
//  @escaping - позволяет closure возвращать параметры
    
    /// создание data task
    ///
    /// - Parameters:
    ///     -  param: URL запрос
    /// - Returns:
    ///     URLSessionDataTask
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            
//            Получение данных в основном потоке
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
