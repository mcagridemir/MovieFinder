//
//  MovieModel.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import Foundation

// MARK: - MovieModel
struct MovieModel: Codable {
    let movies: [Movie]?
    let totalResults: String?

    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults
    }
}

// MARK: - Search
struct Movie: Codable, Equatable {
    let title, year, imdbID: String?
    let type: String?
    let poster: String?
    let released, plot, imdbRating: String?
    var posterX600: String? {
        let posterText = poster?.replace(target: "X300", withString: "X600")
        return posterText
    }
    var releasedDate: String? {
        return Helper.formatDate(dateTxt: released ?? "", inputFormat: "dd MMM yyyy", outputFormat: "yyyy/MM/dd")
    }

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
        case released = "Released"
        case plot = "Plot"
        case imdbRating
    }
}
