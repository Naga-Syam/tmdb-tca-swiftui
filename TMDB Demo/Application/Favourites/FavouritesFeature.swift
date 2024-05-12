//
//  FavouritesFeature.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FavouritesFeature {
    @ObservableState
    struct State {
        var list: [Movie] = []
        var path = StackState<DetailFeature.State>()
        var error: Error?
    }
    
    enum Action {
        case fetchFavourites
        case setFavourites([Movie])
        case path(StackAction<DetailFeature.State, DetailFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchFavourites:
                return .run { send in
                    let favourites = ServiceManager.shared.getFavorites()
                    return await send(.setFavourites(favourites))
                }
            case .setFavourites(let favourites):
                state.list = favourites
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
