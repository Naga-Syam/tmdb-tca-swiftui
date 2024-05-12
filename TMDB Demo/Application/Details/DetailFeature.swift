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
        var item: Movie
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
