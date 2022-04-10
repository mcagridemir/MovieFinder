//
//  HomeViewModel.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import Foundation

class HomeViewModel {
    private(set) var isLoading = Bindable<Bool>()
    private(set) var error = Bindable<Error>()
    private(set) var movies = Bindable<[Movie]>()
    private var movieList = [Movie]()
    private(set) var totalMovieCount = Bindable<String>()
    private var page = 1
    private var limit = 9
    var isMore = true
    var shouldDisplayLoading = false
    var currentMovieCount: Int {
        return movies.value?.count ?? 0
    }
    
    func getMovies(query: String, noLoading: Bool = false, shouldRefresh: Bool = false) {
//        guard isMore else { return }
        if shouldRefresh {
            page = 1
            self.movieList.removeAll()
        }        
//        page = noLoading ? page : 1
        if page == 1 && !noLoading {
            isLoading.value = true
        }
//        page = noLoading ? 1 : page
//        movieList = noLoading ? movieList : []
        MovieRepo.getMovies(urlPrefix: query, page: page) { [weak self] response in
            guard let self = self else { return }
            self.isLoading.value = false
            self.totalMovieCount.value = response.totalResults
            if let movies = response.movies {
//                self.movieList.append(contentsOf: movies)
                movies.forEach { movie in
                    if !(self.movieList.contains(obj: movie)) {
                        self.movieList.append(movie)
                    }
                }
                self.movies.value = self.movieList
            }
            if noLoading {
                self.page += 1
            }
//            if response.movies?.count == 0 {
//                self.isMore = false
//            }
//            self.shouldDisplayLoading = false
            print("a: query \(query)")
            print("a: page \(self.page)")
            print("a: response \(response.movies?.count ?? 0)")
            print("a: movieList.count \(self.movieList.count)")
            print("a: movies.value.count \(self.movies.value?.count ?? 0)")
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.isLoading.value = false
            self.error.value = error
        }
    }
    
    func removeMovies() {
        movies.value?.removeAll()
        movieList.removeAll()
    }
}
