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
                                if !store.searchQuery.isEmpty {
                                    
                                    if let results = store.searchResults {
                                        if results.isEmpty {
                                            Text("No Movie Results Found")
                                        } else {
                                            HorizontalGrid(title: "Search Results - Movies", movies: results)
                                        }
                                    }
                                    
                                    if let results = store.searchResultsTV {
                                        if results.isEmpty {
                                            Text("No TV Results Found")
                                        } else {
                                            HorizontalGrid(title: "Search Results - TV", movies: results)
                                        }
                                    }
                                    
                                } else {
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
                }
                .searchable(text: $store.searchQuery.sending(\.searchQueryChanged))
                .onAppear {
                    store.send(.fetchTrending)
                    store.send(.fetchPopularMovies)
                    store.send(.fetchTvShows)
                }
            }
            .task(id: store.searchQuery) {
              do {
                try await Task.sleep(for: .milliseconds(300))
                await store.send(.searchQueryChangeDebounced).finish()
              } catch {}
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
