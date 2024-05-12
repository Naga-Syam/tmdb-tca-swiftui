//
//  DetailFeature.swift
//  TMDB Demo
//
//  Created by Naga on 11/05/24.
//

import Foundation
import ComposableArchitecture


@Reducer
struct DetailFeature {
    @ObservableState
    struct State {
        var isLoading = false
        var isFavourite = false
        var item: Movie
        var movieCast: [Cast]?
        var error: Error?
    }
    
    enum Action {
        case fetchFavState
        case toggleFavourite
        case fetchMovieCast
        case responseReceived(MovieCastResponse)
        case setError(Error)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchMovieCast:
                state.isLoading = true
                return .run { [movie = state.item] send in
                    do {
                        let discovery: MovieCastResponse = try await ServiceManager.shared.request(urlString: TMDBConstans.getMovieCast(movie.id).urlPath)
                        await send(.responseReceived(discovery))
                    } catch {
                        await send(.setError(error))
                    }
                }
            case .responseReceived(let response):
                state.movieCast = response.cast ?? []
                return .none
            case .setError(let error):
                state.error = error
                return .none
            case .toggleFavourite:
                state.isFavourite = ServiceManager.shared.toggleFavStatus(state.item)
                return .none
            case .fetchFavState:
                state.isFavourite = ServiceManager.shared.hasFavorite(with: state.item)
                return .none
            }
        }
    }
}
