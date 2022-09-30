//
//  NetworkManager .swift
//  WMovie
//
//  Created by Алексей Павленко on 29.09.2022.
//

import Foundation

//MARK: - Custom Errors
enum NetworkManagerError: LocalizedError {
    case urlNotValid
    case responseNotValid
    case noDataFromResponse
    case couldNotDecode
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .urlNotValid:
            return "Provided url is not valid"
        case .responseNotValid:
            return "Response from server is not valid"
        case .couldNotDecode:
            return "Could not decode objects from data provided by response"
        case .noDataFromResponse:
            return "There wasn't any data returned from pesponse"
        case .unknownError:
            return "Unknown error, something went wrong"
        }
    }
}

//MARK: - NetworkManager
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    //MARK: Constants
    static let baseURLForImage = "https://image.tmdb.org/t/p/w500"
    
    //MARK: Request methods
    func send<Request: APIRequest>(request: Request ,completion: @escaping (Result<Request.Response, Error>) -> Void) {
        guard let url = request.requestURL else {
            completion(.failure(NetworkManagerError.urlNotValid))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkManagerError.unknownError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkManagerError.responseNotValid))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkManagerError.noDataFromResponse))
                return
            }
            
            do {
                let decodedObjects = try request.decode(from: data)
                completion(.success(decodedObjects))
            } catch {
                completion(.failure(NetworkManagerError.couldNotDecode))
                print(error)
            }
        }
        dataTask.resume()
    }
    
    func getImageDataFrom(path: String?, completion: @escaping (Data?) -> Void) {
        guard let path = path, let url = URL(string: NetworkManager.baseURLForImage + path) else {
            completion(nil)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            completion(data)
        }
        dataTask.resume()
    }
    
}



