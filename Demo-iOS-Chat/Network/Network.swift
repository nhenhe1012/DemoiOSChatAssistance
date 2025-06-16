//
//  Network.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 17/6/25.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case statusCode(Int, String)
}

protocol APIRequest {
    var baseUrl: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

class ResponseBase {
    var data: [String: Any] = [:]
    required init(dict: [String: Any]) {
        self.data = dict
    }
    func mapping(dict: [String: Any]) { }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func request<T: ResponseBase>(_ endpoint: APIRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: endpoint.baseUrl)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                var message = ""
                if let data = data,
                   let decoded = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let error = decoded["error"] as? [String: Any],
                   let errorMessage = error["message"] as? String {
                    message = errorMessage
                }
                completion(.failure(.statusCode(httpResponse.statusCode, message)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decoded = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                let object = T.init(dict: decoded)
                completion(.success(object))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
