//
//  ServiceManager + Favourites.swift
//  TMDB Demo
//
//  Created by Naga on 12/05/24.
//

import Foundation

extension ServiceManager {
    
    func getFavorites() -> [Movie] {
        return getFavorites().map { Movie(with: $0) }
    }
    
    private func getFavorites() -> [FavouriteItem] {
      var favorites = [FavouriteItem]()
      do {
        favorites = try context.fetch(FavouriteItem.fetchRequest())
      } catch {
        debugPrint("error retrieving cards: \(error)")
      }

      return favorites
    }
    
    func toggleFavStatus(_ movie: Movie) -> Bool {
        if hasFavorite(with: movie) {
            removeFavorite(movie)
            return false
        } else {
            addFavorite(movie)
            return true
        }
    }
    
    private func addFavorite(_ movie: Movie) {
      guard !hasFavorite(with: movie) else { return }
      _ = FavouriteItem.instance(from: movie, with: context)
      CoreData.shared.saveContext()
    }
    
    private func removeFavorite(_ movie: Movie) {
      guard
        let favoriteId = getFavorites().filter({ $0.id == movie.id }).first?.objectID,
        let favoriteCard = context.object(with: favoriteId) as? FavouriteItem
      else { return }
      context.delete(favoriteCard)
      CoreData.shared.saveContext()
    }
    
    
    func hasFavorite(with movie: Movie) -> Bool {
      let favorite = getFavorites().filter { $0.id == movie.id }.first
      return favorite != nil
    }
}
