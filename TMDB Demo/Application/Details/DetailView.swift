//
//  DetailView.swift
//  TMDB Demo
//
//  Created by Naga on 11/05/24.
//

import SwiftUI
import ComposableArchitecture

struct DetailView: View {
    let store: StoreOf<DetailFeature>
    var body: some View {
        Text(store.item.displayTitle ?? "No Title")
    }
}

//#Preview {
//    DetailView(store: <#StoreOf<DetailFeature>#>)
//}
