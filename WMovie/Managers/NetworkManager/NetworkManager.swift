//
//  NetworkManager .swift
//  WMovie
//
//  Created by Алексей Павленко on 29.09.2022.
//

import Foundation

//MARK: - Custom Errors
fileprivate enum NetworkManagerError: LocalizedError {
    case urlNotValid
    case responseNotValid(statusCodeNumber: Int, message: String)
    case noDataFromResponse
    case couldNotDecode
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .urlNotValid:
            return "Provided url is not valid"
        case .responseNotValid(let statusCode, let message):
            return "Error \(statusCode): \(message)"
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
final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    
    //MARK: Request methods
    func send<Request: APIRequest>(request: Request ,completion: @escaping (Result<Request.Response, Error>) -> Void) {
        guard let url = request.requestURL else {
            completion(.failure(NetworkManagerError.urlNotValid))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkManagerError.responseNotValid(statusCodeNumber: 999, message: "Response is not http.")))
                return
            }
            
            guard httpResponse.responseType == .success else {
                completion(.failure(NetworkManagerError.responseNotValid(statusCodeNumber: httpResponse.statusCode, message: httpResponse.status.message)))
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
        guard let path = path, let url = URL(string: APIConstants.tmdbBaseURLForImage + path) else {
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
