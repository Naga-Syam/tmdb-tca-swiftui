//
//  ContentView.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    var body: some View {
        TabView {
            HomeView(store: Store(initialState: HomeFeature.State(), reducer: {
                HomeFeature()
            }))
            .tabItem {
                Image(systemName: "house.circle")
                Text("Home")
            }
            MoviesView(store: Store(initialState: MoviesFeature.State(), reducer: {
                MoviesFeature(dataType: .discoverMovies)
            }), title: "Movies")
            .tabItem {
                Image(systemName: "popcorn.circle")
                Text("Movies")
            }
            MoviesView(store: Store(initialState: MoviesFeature.State(), reducer: {
                MoviesFeature(dataType: .discoverTV)
            }), title: "TV Shows")
            .tabItem {
                Image(systemName: "tv.circle")
                Text("TV Shows")
            }
            FavouritesView(store: Store(initialState: FavouritesFeature.State(), reducer: {
                FavouritesFeature()
            }))
            .tabItem {
                Image(systemName: "heart.circle")
                Text("Fav")
            }
        }
    }
}

#Preview {
    AppView()
}
