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
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video, name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
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


//import Foundation
//
//// MARK: - PopularMovieResponse
//struct PopularMovieResponse: Codable {
//    let page: Int?
//    let results: [Result]?
//    let totalPages, totalResults: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case page, results
//        case totalPages = "total_pages"
//        case totalResults = "total_results"
//    }
//}
//
//// MARK: - Result
//struct Result: Codable {
//    let adult: Bool?
//    let backdropPath: String?
//    let genreIDS: [Int]?
//    let id: Int?
//    let originalLanguage, originalTitle, overview: String?
//    let popularity: Double?
//    let posterPath, releaseDate, title: String?
//    let video: Bool?
//    let voteAverage: Double?
//    let voteCount: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case genreIDS = "genre_ids"
//        case id
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
//        case overview, popularity
//        case posterPath = "poster_path"
//        case releaseDate = "release_date"
//        case title, video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }
//}
