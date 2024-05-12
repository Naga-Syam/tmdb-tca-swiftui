//
//  MoviesFeature.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MoviesFeature {
    @ObservableState
    struct State {
        var isLoading = false
        var list: [Movie] = []
        var path = StackState<DetailFeature.State>()
        var selectedSortOption: SortingOptions = .topRated
        var error: Error?
    }
    
    enum Action {
        case sortSelectionChanged(SortingOptions)
        case fetchList
        case responseReceived(TMDBResponse)
        case setError(Error)
        case path(StackAction<DetailFeature.State, DetailFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case .fetchList:
                state.isLoading = true
                return .run { [sort = state.selectedSortOption.sortBy] send in
                    do {
                        let discovery: TMDBResponse = try await ServiceManager.shared.request(urlString: TMDBConstans.discoverMovies.urlPath, parameters: ["sort_by": sort])
                        await send(.responseReceived(discovery))
                    } catch {
                        await send(.setError(error))
                    }
                }
            case .responseReceived(let response):
                state.list = response.results
                state.isLoading = false
                return .none
                
            case .setError(let error):
                state.error = error
                state.isLoading = false
                return .none
            case .sortSelectionChanged(let selectedSort):
                state.selectedSortOption = selectedSort
                return .run { send in
                    await send(.fetchList)
                }
            }
        }
        .forEach(\.path, action: \.path) {
            DetailFeature()
        }
    }
}

//    discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc
// MARK: SortingOptions
enum SortingOptions: Int, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    case topRated
    case popular
    case nowPlaying
    
    var sortBy: String {
        switch self {
        case .topRated:
            "vote_average.desc"
        case .popular:
            "popularity.desc"
        case .nowPlaying:
            "primary_release_date.desc"
        }
    }
    
    var title: String {
        switch self {
        case .topRated:
            "Top Rated"
        case .popular:
            "Popular"
        case .nowPlaying:
            "Now Playing"
        }
    }
}
