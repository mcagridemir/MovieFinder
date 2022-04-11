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
    private var limit = 10
    var hasMore = true
    var shouldDisplayLoading = false
    var currentMovieCount: Int {
        return movies.value?.count ?? 0
    }
    
    func getMovies(query: String, noLoading: Bool = false, shouldRefresh: Bool = false) {
        if shouldRefresh {
            page = 1
            self.movieList.removeAll()
            hasMore = true
            isLoading.value = true
        }
        guard hasMore else { return }
        MovieRepo.getMovies(urlPrefix: query, page: page) { [weak self] response in
            guard let self = self else { return }
            self.isLoading.value = false
            if let results = response.movies {
                self.hasMore = !(results.count < self.limit)
                self.page += 1
                self.movieList.append(contentsOf: results)
                self.movieList = self.movieList.unique(for: \.imdbID)
                self.movies.value = self.movieList
            } else {
                self.hasMore = false
            }
            self.totalMovieCount.value = response.totalResults
            self.shouldDisplayLoading = false
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.isLoading.value = false
            self.shouldDisplayLoading = false
            self.error.value = error
        }
    }
    
    func removeMovies() {
        movies.value?.removeAll()
        movieList.removeAll()
        totalMovieCount.value = "\(movieList.count)"
        hasMore = false
    }
}
