//
//  FavouritesView.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import SwiftUI
import ComposableArchitecture

struct FavouritesView: View {
    @Bindable var store: StoreOf<FavouritesFeature>
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            NavigationView {
                if store.list.isEmpty {
                   Text("No Favourites added")
                } else {
                    ScrollView {
                        itemsList(store)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Favourites")
            .onAppear() {
                store.send(.fetchFavourites)
            }
        }  destination: { store in
            DetailView(store: store)
        }
    }
    
    @ViewBuilder
    private func itemsList(_ viewStore: StoreOf<FavouritesFeature>) -> some View {
        let gridItem = GridItem(.flexible(minimum: 80, maximum: 180))
        LazyVGrid(
            columns: [gridItem, gridItem, gridItem],
            alignment: .center,
            spacing: 16,
            content: {
                ForEach(viewStore.list) { movie in
                    CardItemView(card: movie, isFavorite: false)
                }
            }
        )
    }
}
