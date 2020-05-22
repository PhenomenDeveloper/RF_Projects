//
//  NetworkDataFetcher.swift
//  AwesomeDebouncer
//
//  Created by Lev Kolesnikov on 29.12.2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getSuggestionsData(searchWord: String, path: String, completion: @escaping (NetworkHintModel?) -> ())
}

struct NetworkDataFetcher: DataFetcher {
    
    ///Объект которые осуществляет запрос в сеть
    let networking: Netwoking
    
    init(networking: Netwoking = NetworkService()) {
        self.networking = networking
    }
    
    ///Получает историю транзакций пользователя
    ///
    /// - Parameters:
    ///     - completion: Блок кода который необходимо выполнить, когда данные будут получены с сервера
    func getSuggestionsData(searchWord: String, path: String, completion: @escaping (NetworkHintModel?) -> ()) {
        
        networking.getSuggestionsData(searchWord: searchWord, path: path) { (data, error) in
            if let error = error {
                print("Ошибка получения данных истории транзакций:  \(error.localizedDescription)")
                completion(nil)
            }
            
            let decoded = self.decodeJSON(type: NetworkHintModel.self, from: data)
            completion(decoded)
        }
    }
    
    ///Декодирует данные полученные из интернета в модель подготовленную для них
    ///
    /// - Parameters:
    ///     - type: Куда хотим упаковать полученный данные
    ///     - from: Данные полученный из сети, которые хотим распокавать
    /// - Returns:
    ///     Возвращает модель заполненную данными полученными из сети
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from else { return nil }
        var response: T?
        do {
            response = try decoder.decode(type.self, from: data)
        } catch {
            print("Ошибка декодирования - \(error)")
        }
        return response
    }
}
