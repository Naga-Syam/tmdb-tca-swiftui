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
        newFavorite.name = movie.name
        newFavorite.rating = movie.voteAverage ?? 0
        newFavorite.movieId = Int32(movie.id ?? 0)
        newFavorite.posterPath = movie.posterPath
        return newFavorite
    }
}

