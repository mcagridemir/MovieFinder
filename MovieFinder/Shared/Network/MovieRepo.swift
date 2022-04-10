//
//  MovieRepo.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import Foundation

class MovieRepo {
    class func getMovies(urlPrefix: String, page: Int? = nil, success: @escaping(_ response: MovieModel) -> Void, failure: @escaping(_ error: Error) -> Void) {
        APIManager.shared.fetchApi(router: .Get(UrlPrefix: urlPrefix, page: page)) { (response: MovieModel) in
            success(response)
        } callbackFailure: { error in
            failure(error)
        }
    }
    
    class func getMovie(id: String,  success: @escaping(_ response: Movie) -> Void, failure: @escaping(_ error: Error) -> Void) {
        APIManager.shared.fetchApi(router: .Get(UrlPrefix: id)) { (response: Movie) in
            success(response)
        } callbackFailure: { error in
            failure(error)
        }
    }
}
