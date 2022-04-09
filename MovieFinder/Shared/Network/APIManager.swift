//
//  APIManager.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
    func fetchApi<T: Decodable>(
        router: Services, callbackSuccess: @escaping (T) -> Void, callbackFailure: @escaping (Error) -> Void
    ) {
        ServiceConnector.shared.connect(router) { (target, response) in
            if let jsonData = response.data(using: .utf8) {
                if let object = try? JSONDecoder().decode(T.self, from: jsonData) {
                    callbackSuccess(object)
                } else {
                    callbackFailure(.ParseFailed)
                }
            }
        }
    }
}
