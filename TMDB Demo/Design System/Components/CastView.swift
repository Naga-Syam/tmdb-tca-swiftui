//
//  CastView.swift
//  TMDB Demo
//
//  Created by Naga on 12/05/24.
//

import SwiftUI

struct CastView: View {

    let cast: Cast

    var body: some View {
        VStack {
            AsyncImage(url: cast.profilePic) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 120)
            }
            Text(cast.name ?? "")
                .font(.caption)
                .lineLimit(1)
                .frame(width: 100)
        }
    }

}
