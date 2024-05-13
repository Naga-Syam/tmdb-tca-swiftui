//
//  HomeReducer.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct HomeFeature {
    
    @ObservableState
    struct State {
        var searchQuery: String = ""
        var isLoading = false
        var trending: [Movie]?
        var popularMovies: [Movie]?
        var tvShows: [Movie]?
        var searchResults: [Movie]?
        var searchResultsTV: [Movie]?
        var errors: [ListCategory: Error] = [:]
        var path = StackState<DetailFeature.State>()
    }
    
    enum Action {
        case fetchTrending
        case fetchPopularMovies
        case fetchTvShows
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case fetchSearchMovieResults
        case fetchSearchTVResults
        case cancelMoviesSearch
        case cancelTVSearch
        case receivedResponse(ListCategory, TMDBResponse)
        case setError(ListCategory, Error)
        case setLoading(Bool)
        case path(StackAction<DetailFeature.State, DetailFeature.Action>)
    }
    
    enum ListCategory {
        case trending
        case popularMovies
        case tvShows
        case search
        case searchTV
    }
    
    private enum CancelID {
        case searchMovies
        case searchTV
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchTrending:
                state.isLoading = true
                return .run { send in
                    do {
                        let trending: TMDBResponse = try await ServiceManager.shared.request(urlString: TMDBConstans.trending.urlPath)
                        await send(.receivedResponse(.trending, trending))
                    } catch {
                        await send(.setError(.trending, error))
                    }
                }
                
            case .fetchPopularMovies:
                state.isLoading = true
                return .run { send in
                    do {
                        let trending: TMDBResponse = try await ServiceManager.shared.request(urlString: TMDBConstans.popular.urlPath)
                        await send(.receivedResponse(.popularMovies, trending))
                    } catch {
                        await send(.setError(.popularMovies, error))
                    }
                }
                
            case .fetchTvShows:
                state.isLoading = true
                return .run { send in
                    do {
                        let trending: TMDBResponse = try await ServiceManager.shared.request(urlString: TMDBConstans.trendingTV.urlPath)
                        await send(.receivedResponse(.tvShows, trending))
                    } catch {
                        await send(.setError(.tvShows, error))
                    }
                }
                
            case .searchQueryChanged(let query):
                state.searchQuery = query
                guard !state.searchQuery.isEmpty else {
                    state.searchResults = nil
                    state.searchResultsTV = nil
                    return .run { send in
                        await send(.cancelTVSearch)
                        await send(.cancelMoviesSearch)
                    }
                }
                return .none
                
            case .searchQueryChangeDebounced:
                guard !state.searchQuery.isEmpty else {
                    return .none
                }
                return .run { send in
                    await send(.fetchSearchMovieResults)
                    await send(.fetchSearchTVResults)
                }
                
            case .receivedResponse(let category, let response):
                state.isLoading = false
                switch category {
                case .trending:
                    state.trending = response.results
                    return .none
                case .popularMovies:
                    state.popularMovies = response.results
                    return .none
                case .tvShows:
                    state.tvShows = response.results
                    return .none
                case .search:
                    state.searchResults = response.results
                    return .none
                case .searchTV:
                    state.searchResultsTV = response.results
                    return .none
                }
            case .setError(let category, let error):
                state.errors[category] = error
                return .none
            case .setLoading(let loading):
                state.isLoading = loading
                return .none
            case .path:
                return .none
            case .fetchSearchMovieResults:
                state.isLoading = true
                return .run { [search = state.searchQuery] send in
                    do {
                        let results: TMDBResponse = try await ServiceManager.shared.request(urlString: TMDBConstans.searchMovies.urlPath, parameters: ["query": search])
                        await send(.receivedResponse(.search, results))
                    } catch {
                        await send(.setError(.search,error))
                    }
                }
                .cancellable(id: CancelID.searchMovies)
                
            case .fetchSearchTVResults:
                state.isLoading = true
                return .run { [search = state.searchQuery] send in
                    do {
                        let results: TMDBResponse = try await ServiceManager.shared.request(urlString: TMDBConstans.searchTV.urlPath, parameters: ["query": search])
                        await send(.receivedResponse(.searchTV, results))
                    } catch {
                        await send(.setError(.searchTV,error))
                    }
                }
                .cancellable(id: CancelID.searchTV)
            case .cancelMoviesSearch:
                state.isLoading = false
                return .cancel(id: CancelID.searchMovies)
            case .cancelTVSearch:
                state.isLoading = false
                return .cancel(id: CancelID.searchTV)
            }
        }
        .forEach(\.path, action: \.path) {
            DetailFeature()
        }
    }
}
