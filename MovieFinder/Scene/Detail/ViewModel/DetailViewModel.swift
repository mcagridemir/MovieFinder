//
//  DetailViewModel.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 10.04.2022.
//

import Foundation

class DetailViewModel {
    private(set) var isLoading = Bindable<Bool>()
    private(set) var error = Bindable<Error>()
    private(set) var movie = Bindable<Movie>()
    var id: String?
    
    func getMovie() {
        isLoading.value = true
        guard let id = id else { return }
        MovieRepo.getMovie(id: id) { [weak self] response in
            guard let self = self else { return }
            self.isLoading.value = false
            self.movie.value = response
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.isLoading.value = false
            self.error.value = error
        }
    }
}
