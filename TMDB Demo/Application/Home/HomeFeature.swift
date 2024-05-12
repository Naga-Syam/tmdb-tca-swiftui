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
        var isLoading = false
        var trending: [Movie]?
        var popularMovies: [Movie]?
        var tvShows: [Movie]?
        var errors: [ListCategory: Error] = [:]
        var path = StackState<DetailFeature.State>()
    }
    
    enum Action {
        case fetchTrending
        case fetchPopularMovies
        case fetchTvShows
        case receivedResponse(ListCategory, TMDBResponse)
        case setError(ListCategory, Error)
        case setLoading(Bool)
        case path(StackAction<DetailFeature.State, DetailFeature.Action>)
    }
    
    enum ListCategory {
        case trending
        case popularMovies
        case tvShows
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
                }
            case .setError(let category, let error):
                state.errors[category] = error
                return .none
            case .setLoading(let loading):
                state.isLoading = loading
                return .none
            case .path:
                return .none
            }
        }
        
        .forEach(\.path, action: \.path) {
              DetailFeature()
        }
    }
}
