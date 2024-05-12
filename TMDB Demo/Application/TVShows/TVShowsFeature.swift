//
//  TVShowsFeature.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TVShowsFeature {
    @ObservableState
    struct State: Equatable {
        var isLoading = false
        var fact: String?
    }
    
    enum Action {
        case fetchList
        case factResponse(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .factResponse(let fact):
                state.isLoading = false
                state.fact = fact
                return .none
            case .fetchList:
                state.isLoading = true
                state.fact = nil
                return .run { send in
                    let (data, _) = try await URLSession.shared
                        .data(from: URL(string: "http://numbersapi.com/1")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    await send(.factResponse(fact))
                }
            }
        }
    }
}
