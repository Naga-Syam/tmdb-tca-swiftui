//
//  HorizontalGrid.swift
//  TMDB Demo
//
//  Created by Naga on 11/05/24.
//

import SwiftUI

// MARK: - HorizontalGrid
struct HorizontalGrid: View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12.0) {
                    ForEach(movies) { movie in
                        CardItemView(card: movie, isFavorite: false)
                            .frame(width: 134)
                    }
                }
                .padding(.horizontal)
                .frame(height: 230)
            }
            
        }
        .padding(.bottom)
    }
}

// MARK: - CardItemView
import Kingfisher
import ComposableArchitecture
struct CardItemView: View {
    let card: Movie
    let isFavorite: Bool
    
    var body: some View {
        NavigationLink(state: DetailFeature.State(item: card)) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 4) {
                    KFImage(card.posterURL)
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .aspectRatio(CGSize(width: 134, height: 180), contentMode: .fill)
                        .clipped()
                        .frame(maxWidth: .infinity)
                    HStack {
                        VStack {
                            HStack {
                                Image(systemName: "star.fill")
                                    .imageScale(.small)
                                    .foregroundColor(.yellow)
                                Text("\(card.voteAverage ?? 0.0, specifier: "%.2f")")
                                    .font(.caption)
                                    .lineLimit(1)
                                Spacer()
                            }
                            HStack {
                                Text(card.displayTitle ?? "")
                                    .font(.caption)
                                    .lineLimit(1)
                                Spacer()
                            }
                        }
                        Spacer()
                        if isFavorite {
                            Image(systemName: "star.fill")
                                .imageScale(.small)
                        }
                    }
                }
            }
        }
    }
}
