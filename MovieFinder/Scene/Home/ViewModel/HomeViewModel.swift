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
//        guard hasMore else { return }
        if shouldRefresh {
            page = 1
            self.movieList.removeAll()
            hasMore = true
            isLoading.value = true
        }        
//        page = noLoading ? page : 1
//        if page == 1 && !noLoading {
//            isLoading.value = true
//        }
//        page = noLoading ? 1 : page
//        movieList = noLoading ? movieList : []
        MovieRepo.getMovies(urlPrefix: query, page: page) { [weak self] response in
            guard let self = self else { return }
            self.isLoading.value = false
            self.totalMovieCount.value = response.totalResults
//            self.movieList = []
            if let results = response.movies {
                if results.count < self.limit {
                    self.hasMore = false
                }
                self.page += 1
                self.movieList.append(contentsOf: results)
                self.movieList = self.movieList.unique(for: \.imdbID)
                self.movies.value = self.movieList
//                self.movieList.append(contentsOf: results)
//                results.forEach { movie in
//                    if !(self.movieList.contains(obj: movie)) {
//                        self.movieList.append(movie)
//                    }
//                }
            } else {
                self.hasMore = false
            }
//            if noLoading {
//                self.page += 1
//            }
//            if response.movies?.count == 0 {
//                self.isMore = false
//            }
//            self.shouldDisplayLoading = false
            print("a: query \(query)")
            print("a: page \(self.page)")
            print("a: hasMore \(self.hasMore)")
            print("a: response.count \(response.movies?.count ?? 0)")
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
        totalMovieCount.value = "\(movieList.count)"
        hasMore = false
    }
}
