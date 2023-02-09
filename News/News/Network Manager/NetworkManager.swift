//
//  NetworkManager.swift
//  News
//
//  Created by Baidetskyi Jurii on 29.01.2023.
//

import Foundation

final class NetworkManager: NetworkManageable {

    private(set) var baseURL = "https://newsapi.org"
    private let urlSession: URLSession
    
    init() {
        urlSession = URLSession.shared
    }
    
    func loadRequest<T: Codable>(methodPath: String, 
                                 methodType: String,
                                 queryParams: [String : String]?,
                                 bodyParams: [String : Any]?,
                                 resultHandler: @escaping (ResponseResult<T>) -> Void) {
        guard let fullUrl = configURLComponents(baseUrl: baseURL, path: methodPath, queryItems: queryParams)?.url else {
            // TODO: Error
            resultHandler(.failure(.developerError))
            return
        }
        print(fullUrl)
        
        var urlRequest = URLRequest(url: fullUrl)
        urlRequest.httpBody =  configRequestBody(params: bodyParams)
        urlRequest.httpMethod = methodType
        urlRequest.addValue("e082e7ebc7cf494b8c81007e4c54c72a", forHTTPHeaderField: "X-Api-Key")
        
        let urlTask = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let `self` = self else {
            return
            }
            if let error = error {
                resultHandler(.failure(.repsonseError(error.localizedDescription)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                resultHandler(.failure(.unknownError))
                return
            }
            if httpResponse.statusCode <= 299 && httpResponse.statusCode >= 200 {
            
                guard let data = data else {
                    resultHandler(.failure(.noData))
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                
                if let result = try? decoder.decode(T.self, from: data) {
                    resultHandler(.success(result))
                } else {
                    resultHandler(.failure(.unknownError))
                }
                return
            }
            self.handlerError(with: httpResponse, data: data, resultHandler: resultHandler)
        }
        urlTask.resume()
    }
    
    private func handlerError<T: Codable>(with response: HTTPURLResponse, data: Data?, resultHandler: @escaping (_ result: ResponseResult<T>) -> Void) {
        
        switch response.statusCode {
        case 100...199: resultHandler(.failure(.processing))
        case 300...399: resultHandler(.failure(.redirection))
        case 401: resultHandler(.failure(.nonAuthorized))
        case 400...499: resultHandler(.failure(.badRequest))
        case 500...599: resultHandler(.failure(.serverError))
        default:
            return
        }
    }
    
    private func configRequestBody(params: [String: Any]?) -> Data? {
        guard let params = params else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    }
    
    private func configURLComponents(baseUrl: String,
                                     path: String,
                                     queryItems: [String : String]?
    ) -> URLComponents? {
        guard let baseUrl = URL(string: baseUrl) else {
            return nil
        }
        
        let url = baseUrl.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        guard let queryItems = queryItems else {
            return components
        }
        
        var items = [URLQueryItem]()
        for (key, value) in queryItems {
            let item = URLQueryItem(name: key, value: value)
            items.append(item)
        }
        components?.queryItems = items
        
        return components
    }
    
}
