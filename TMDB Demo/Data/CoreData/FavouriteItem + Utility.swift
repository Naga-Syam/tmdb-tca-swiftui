//
//  FavouriteItem + Utility.swift
//  TMDB Demo
//
//  Created by Naga on 12/05/24.
//

import Foundation
import CoreData

extension FavouriteItem {
    static func instance(from movie: Movie, with context: NSManagedObjectContext) -> FavouriteItem {
        let newFavorite = FavouriteItem(context: context)
        newFavorite.id = Int32(movie.id)
        newFavorite.name = movie.name
        newFavorite.title = movie.title
        newFavorite.backdropPath = movie.backdropPath
        newFavorite.overview = movie.overview
        newFavorite.posterPath = movie.posterPath
        newFavorite.voteAverage = movie.voteAverage ?? 0
        newFavorite.popularity = movie.popularity ?? 0
        return newFavorite
    }
}

