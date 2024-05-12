//
//  MoviesView.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import SwiftUI
import ComposableArchitecture

struct MoviesView: View {
    @Bindable var store: StoreOf<MoviesFeature>
    @State private var selectedSegment = SortingOptions.topRated
    let title: String
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            NavigationView {
                VStack {
                    sortSegments(store, option: $selectedSegment)
                        .padding(.horizontal)
                    Spacer()
                    if let error = store.error {
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                    } else if store.isLoading {
                        ProgressView()
                    } else {
                        ScrollView {
                            itemsList(store)
                                .padding(.horizontal)
                        }
                    }
                }
                .onAppear() {
                    store.send(.fetchList)
                }
                .navigationTitle(title)
            }
        }  destination: { store in
            DetailView(store: store)
        }
    }
    
    @ViewBuilder
    private func itemsList(_ viewStore: StoreOf<MoviesFeature>) -> some View {
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
    
    @ViewBuilder
    private func sortSegments(_ viewStore: StoreOf<MoviesFeature>, option: Binding<SortingOptions>) -> some View {
        Picker(selection: option, label: Text("Select a segment")) {
            ForEach(SortingOptions.allCases) { sortOption in
                Text("\(sortOption.title)").tag(sortOption)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .onChange(of: selectedSegment) { oldValue, newValue in
            viewStore.send(.sortSelectionChanged(newValue))
        }
    }
}
