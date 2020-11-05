//
//  APIClient.swift
//  NetworkDemo
//
//  Created by a.dirsha on 03.11.2020.
//

import Foundation

protocol NetworkOperation: class {
    func cancel()
}

extension URLSessionDataTask: NetworkOperation {  }

final class APIClient {
    private let session = URLSession(configuration: .default)
    
    private let baseComplnents: URLComponents
    
    private let jsonDecoder: JSONDecoder = {
        var result = JSONDecoder()
        result.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        result.dateDecodingStrategy = .formatted(dateFormatter)
        return result
    }()
    
    init() {
        var baseComplnents = URLComponents()
        
        baseComplnents.scheme = "https"
        baseComplnents.host = "api.nasa.gov"
        baseComplnents.queryItems = [URLQueryItem(name: "api_key", value: "UQHy0LsLXYGU2jyhRvbxH0VwZlNmbOl3XBDepnt6")]
        
        self.baseComplnents = baseComplnents
    }
    
    @discardableResult
    func dataTask<T: Decodable>(_ path: String, completion: @escaping (Result<T, Error>) -> Void) -> NetworkOperation? {
        guard let url = self.makeURL(path: path) else {
            completion(.failure(InternalError.unknownPath))
            return nil
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = self.session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            else if let data = data {
                do {
                    let result = try self.jsonDecoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                }
                catch let error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(.failure(InternalError.internalServerError))
                }
            }
        }
        task.resume()
        
        return task
    }
    
    private func makeURL(path: String) -> URL? {
        var result = self.baseComplnents
        result.path = "/mars-photos/api/v1/\(path)"
        return result.url
    }
    
    
    enum InternalError: Error {
        case unknownPath
        case internalServerError
    }
}
