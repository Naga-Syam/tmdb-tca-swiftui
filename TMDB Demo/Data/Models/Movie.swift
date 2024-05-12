//
//  Movie.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import Foundation

// MARK: - Movie
struct TMDBResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Movie: Codable, Identifiable {
    let backdropPath: String?
    let id: Int
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let voteAverage: Double?
    let name: String?
    let title: String?
    
    init(id: Int, name: String?, title: String?,posterPath: String?, voteAverage: Double?) {
        self.name = name
        self.title = title
        self.posterPath = posterPath
        self.id = id
        self.voteAverage = voteAverage
        self.popularity = nil
        self.backdropPath = nil
        self.overview = nil
    }

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case overview, popularity, title
        case posterPath = "poster_path"
        case name
        case voteAverage = "vote_average"
    }
    
    var posterURL: URL? {
        return URL(string: TMDBConstans.imageBaseURL + (self.posterPath ?? ""))
    }
    
    var backDropURL: URL? {
        return URL(string: TMDBConstans.imageBaseURLLarge + (self.backdropPath ?? ""))
    }
    
    var displayTitle: String? {
        return title == nil ? name : title
    }
}

extension Movie {
    init(with favorite: FavouriteItem) {
        self.name = favorite.name
        self.title = favorite.title
        self.posterPath = favorite.posterPath
        self.id = Int(favorite.id)
        self.voteAverage = favorite.voteAverage
        self.popularity = favorite.popularity
        self.backdropPath = favorite.backdropPath
        self.overview = favorite.overview
        
    }
}
