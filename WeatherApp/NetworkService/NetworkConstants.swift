//
//  NetworkConstants.swift
//  WeatherApp
//
//  Created by Victoria Belinschi on 07.06.2023.
//

import Foundation

public struct RequestEntity {
    let path: String
    let queryItems: [URLQueryItem]?
    let headers: [String: String]?
    let body: Data?
    let htttpMethod: HTTPMethod

    init(path: String,
         queryItems: [URLQueryItem]? = nil,
         headers: [String: String]? = ["Content-Type": "application/json; charset=UTF-8"],
         body: Data? = nil,
         htttpMethod: HTTPMethod) {
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.htttpMethod = htttpMethod
    }
}

public struct BaseURL {
    static let scheme: String = "https"
    static let host: String = "api.weatherapi.com"
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum NetworkError: Error {
    case transportError(Error)
    case serverError(Data?)
    case noData
    case unauthorized
    case unauthorizedAfterRefresh
    case notFoundURL
    case genericError(Error)

    public var errorDescription: String? {
            switch self {
            case .transportError(let error):
                return NSLocalizedString("Transport error: \(error.localizedDescription)", comment: "")
            case .serverError(let data):
                if let data = data {
                    return NSLocalizedString("Server error: \(String(data: data, encoding: .utf8) ?? "")", comment: "")
                } else {
                    return NSLocalizedString("Server error", comment: "")
                }
            case .noData:
                return NSLocalizedString("No data received", comment: "")
            case .unauthorized:
                return NSLocalizedString("Unauthorized", comment: "")
            case .unauthorizedAfterRefresh:
                return NSLocalizedString("Unauthorized after refresh", comment: "")
            case .notFoundURL:
                return NSLocalizedString("Not found URL", comment: "")
            case .genericError(let error):
                return NSLocalizedString("Error: \(error.localizedDescription)", comment: "")
            }
        }
}
