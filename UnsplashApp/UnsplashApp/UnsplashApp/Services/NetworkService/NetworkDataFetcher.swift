//
//  NetworkDataFetcher.swift
//  UnsplashApp
//
//  Created by OMELCHUK Daniil on 26/12/2019.
//  Copyright © 2019 OMELCHUK Daniil. All rights reserved.
//

import Foundation

class NetworkDataFetcher {
    
    var networkService = NetworkService()
    
    
    func fetchImages(serachTerm: String, page: Int, completion: @escaping (SearchResults?) -> ()) {
        networkService.request(searchTerm: serachTerm, page: page) { (data, error) in
            if let error = error {
                print("Error recevied requesting data:  \(error.localizedDescription)")
                completion(nil)
            }
            
            let decoded = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decoded)
        }
    }
    
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
    
}

