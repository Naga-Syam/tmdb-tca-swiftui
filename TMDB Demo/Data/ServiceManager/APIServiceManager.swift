//
//  APIServiceManager.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import Foundation

enum TMDBConstans {
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w154"
    static let imageBaseURLLarge = "https://image.tmdb.org/t/p/original"
    case trending
    case popular
    case trendingTV
    case discoverMovies
    case discoverTV
    case getMovieCast(Int)
    case searchMovies
    case searchTV
    var urlPath: String {
        switch self {
        case .trending:
            "\(Self.baseURL)/trending/movie/day"
        case .popular:
            "\(Self.baseURL)/movie/popular"
        case .trendingTV:
            "\(Self.baseURL)/trending/tv/day"
        case .discoverMovies:
            "\(Self.baseURL)/discover/movie"
        case .discoverTV:
            "\(Self.baseURL)/discover/tv"
        case .getMovieCast(let movieId):
            "\(Self.baseURL)/movie/\(movieId)/credits"
        case .searchMovies:
            "\(Self.baseURL)/search/movie"
        case .searchTV:
            "\(Self.baseURL)/search/tv"
        }
    }
}

class ServiceManager {
    static let shared = ServiceManager()
    let context = CoreData.shared.context
    
    func request<T: Decodable> (urlString: String, parameters: [String: String] = [:]) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
    
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        guard let requestUrl = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: requestUrl)
        
        request.allHTTPHeaderFields = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5YTIyMWU5OTQ2YTgwMDc0NmFlZjFkNmRiODMwZGM4MyIsInN1YiI6IjY2M2RjOTgzZGRlZjY0MjhlNzBmN2M3NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uvvPWezRS-SPorXcKnXM5pFOKT--wEcejMeBJIm6uCA"]
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let datatResponse = try JSONDecoder().decode(T.self, from: data)
        return datatResponse
    }
}
