//
//  ContentView.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppFeature>
    var body: some View {
        TabView {
            HomeView(store: store.scope(state: \.tab1, action: \.tab1))
            .tabItem {
                Image(systemName: "house.circle")
                Text("Home")
            }
            MoviesView(store: store.scope(state: \.tab2, action: \.tab2), title: "Movies")
            .tabItem {
                Image(systemName: "popcorn.circle")
                Text("Movies")
            }
            MoviesView(store: store.scope(state: \.tab3, action: \.tab3), title: "TV Shows")
            .tabItem {
                Image(systemName: "tv.circle")
                Text("TV Shows")
            }
            FavouritesView(store: store.scope(state: \.tab4, action: \.tab4))
            .tabItem {
                Image(systemName: "heart.circle")
                Text("Fav")
            }
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State(), reducer: {
        AppFeature()
    }))
}
