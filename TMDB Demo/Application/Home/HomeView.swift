//
//  HomeView.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    @State private var searchText: String = ""
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            NavigationView {
                VStack {
                    if let trendingError = store.errors[.trending],
                       let newError = store.errors[.popularMovies],
                       let recommendedError = store.errors[.tvShows] {
                        Text("Error: \(trendingError.localizedDescription), \(newError.localizedDescription), \(recommendedError.localizedDescription)")
                            .foregroundColor(.red)
                    } else if store.isLoading {
                        ProgressView()
                    } else {
                        ScrollView {
                            VStack {
                                if let movies = store.trending {
                                    HorizontalGrid(title: "Trending", movies: movies)
                                }
                                if let movies = store.popularMovies {
                                    HorizontalGrid(title: "Popular Movies", movies: movies)
                                }
                                if let movies = store.tvShows {
                                    HorizontalGrid(title: "TV Shows", movies: movies)
                                }
                            }
                        }
                    }
                }
                .searchable(text: $searchText) {  // <-- Add searchable modifier
                    if searchText.isEmpty {
                        
                    } else {
                        ForEach(0..<10) { index in  // <-- Customize your search results
                            Text("Search Result \(index)")
                        }
                    }
                    
                }
                .onAppear {
                    store.send(.fetchTrending)
                    store.send(.fetchPopularMovies)
                    store.send(.fetchTvShows)
                }
            }
        }  destination: { store in
            DetailView(store: store)
        }
    }
}


#Preview {
    HomeView(store: Store(initialState: HomeFeature.State(), reducer: {
        HomeFeature()
    }))
}
