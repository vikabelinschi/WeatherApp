//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Victoria Belinschi on 07.06.2023.
//

import Foundation
import Combine

protocol NetworkService {
    func request(httpRequest: RequestEntity) -> AnyPublisher<Data,NetworkError>
}

class NetworkServiceImp: NetworkService {

    let urlSession: URLSession

    // MARK: - Initializers

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    // MARK: - Public Methods
    
    func request(httpRequest: RequestEntity) -> AnyPublisher<Data,NetworkError> {
        guard let url = getURL(httpRequest: httpRequest).url else {
            return Fail(error: NetworkError.notFoundURL)
                .eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: getRequest(url: url, httpRequest: httpRequest))
            .map({ $0.data })
            .mapError { error in
                return NetworkError.genericError(error)
            }.eraseToAnyPublisher()
    }

    // MARK: - Private Methods
    private func getURL(httpRequest: RequestEntity) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = BaseURL.scheme
        urlComponents.host = BaseURL.host
        urlComponents.path = httpRequest.path
        urlComponents.queryItems = httpRequest.queryItems
        return urlComponents
    }

    private func getRequest(url: URL, httpRequest: RequestEntity) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpRequest.htttpMethod.rawValue
        request.httpBody = httpRequest.body
        request.allHTTPHeaderFields = httpRequest.headers
        return request
    }
}

