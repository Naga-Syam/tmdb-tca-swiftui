//
//  DetailView.swift
//  TMDB Demo
//
//  Created by Naga on 11/05/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct DetailView: View {
    let store: StoreOf<DetailFeature>
    @Environment(\.dismiss) private var dismiss
    let headerHeight: CGFloat = 300
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 12) {
                    GeometryReader { geo in
                        AsyncImage(url: store.item.backDropURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: headerHeight)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        } placeholder: {
                            ProgressView()
                                .frame(width: geo.size.width, height: headerHeight)
                        }
                    }
                    Spacer()
                        .frame(height: headerHeight - 30)
                    VStack(spacing: 12) {
                        HStack {
                            Text(store.item.displayTitle ?? "")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        RatingView(rating: store.item.voteAverage ?? 0.0)
                        HStack {
                            Text("About film")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        Text(store.item.overview ?? "")
                            .lineLimit(2)
                            .foregroundColor(.secondary)
                        
                        if let movieCast = store.movieCast {
                            HStack {
                                Text("Cast & Crew")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(movieCast) { cast in
                                        CastView(cast: cast)
                                    }
                                }
                            }
                        }
                        
                    }
                    .padding()
                }
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            CustomBackButton(dismiss: dismiss)
                .padding(.leading)
        }
        .onAppear() {
            store.send(.fetchMovieCast)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}


struct CustomBackButton: View {
    let dismiss: DismissAction
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .fontWeight(.bold)
        }
    }
}

//#Preview {
//    DetailView(store: <#StoreOf<DetailFeature>#>)
//}
