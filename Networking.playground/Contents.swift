import Foundation

enum DynamicJSONProperty: Codable {
    case int(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container =  try decoder.singleValueContainer()
        
        // Decode the double
        do {
            let intVal = try container.decode(Int.self)
            self = .int(intVal)
        } catch DecodingError.typeMismatch {
            // Decode the string
            let stringVal = try container.decode(String.self)
            self = .string(stringVal)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}

struct API {
    static let scheme = "http"
    static let host = "localhost"
    static let path = "/homework"
    static let variant = "7"
}

struct FeedResponse: Codable {
    var id: Int
    var description: String
    var json: Result
    
    struct Result: Codable {
        var results: [AlbumObject]
        
        struct AlbumObject: Codable {
              var wrapperType: String
              var collectionType: String
              var artistId: Int
              var collectionId: DynamicJSONProperty
              var amgArtistId: Int
              var artistName: String?
              var collectionName: String
              var collectionCensoredName: String
              var artistViewUrl: URL
              var collectionViewUrl: URL
              var artworkUrl60: URL
              var artworkUrl100: URL
              var collectionPrice: Double
              var collectionExplicitness: String
              var trackCount: Int
              var copyright: String?
              var country: String
              var currency: String
              var releaseDate: Date
              var primaryGenreName: String
        }
    }
}

// MARK: - Network Layer

protocol Networking {
    func request(completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: Networking {

//    построение запроса данных по URL
    func request(completion: @escaping (Data?, Error?) -> Void) {
        let variant = API.variant
        
        var url = self.componentsToURL()
        url.appendPathComponent(variant)
        
        var request = URLRequest(url: url)

        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func componentsToURL() -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.path
        return components.url!
    }

//  @escaping - позволяет closure возвращать параметры
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
//            Получение данных в основном потоке
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}

// MARK: - Data Fetcher Layer

class NetworkDataFetcher {

    var networkService = NetworkService()

    func fetchAlbums(completion: @escaping (FeedResponse?) -> ()) {
        networkService.request() { (data, error) in
            if let error = error {
                print("Error recevied requesting data:  \(error.localizedDescription)")
                completion(nil)
            }

            let decoded = self.decodeJSON(type: FeedResponse.self, from: data)
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                encoder.dateEncodingStrategy = .iso8601
                
                let data = try encoder.encode(decoded)
                print("----------------")
                print("Вывод encode данных:")
                print("Альбомы: \(String(data: data, encoding: .utf8)!)")
            } catch {
                print(error.localizedDescription)
            }
                    
            completion(decoded)
        }
    }


    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
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

var networkDataFetcher = NetworkDataFetcher()

networkDataFetcher.fetchAlbums { (albums) in
    guard let items = albums else { return }
    print("----------------")
    print("Работа с полученными данными")
    print("Общее количество альбомов - \(items.json.results.count) шт.")
//    printAlbumsByDates(albums: items.json.results)
}
//
//private func printAlbumsByDates(albums: [FeedResponse.Result.AlbumObject]) {
//
//     let sortDates = albums.map {$0.releaseDate}.sorted(by: <)
//     print("Даты альбомов по возрастанию - \(sortDates) ")
//
//}






