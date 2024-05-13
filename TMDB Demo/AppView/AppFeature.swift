//
//  AppReducer.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
    struct State {
        var tab1 = HomeFeature.State()
        var tab2 = MoviesFeature.State()
        var tab3 = MoviesFeature.State()
        var tab4 = FavouritesFeature.State()
    }
    
    enum Action {
        case tab1(HomeFeature.Action)
        case tab2(MoviesFeature.Action)
        case tab3(MoviesFeature.Action)
        case tab4(FavouritesFeature.Action)
    }
    var body: some ReducerOf<Self> {
        
        Scope(state: \.tab1, action: \.tab1) {
            HomeFeature()
        }
        
        Scope(state: \.tab2, action: \.tab2) {
            MoviesFeature(dataType: TMDBConstans.discoverMovies)
        }
        
        Scope(state: \.tab3, action: \.tab3) {
            MoviesFeature(dataType: TMDBConstans.discoverTV)
        }
        
        Scope(state: \.tab4, action: \.tab4) {
            FavouritesFeature()
        }
        
        Reduce { state, action in
            return .none
        }
    }
}
