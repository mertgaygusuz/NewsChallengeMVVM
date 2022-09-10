//
//  FavoritesTableViewModel.swift
//  NewsApp
//
//  Created by Mert Gaygusuz on 9.09.2022.
//

import UIKit
import CoreData

final class FavoritesTableViewModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var favoritedNews: [FavoriteNewsItem] = []
    
    init() {
        getFavoritedNews()
    }
    
    func getFavoritedNews() {
        do {
            favoritedNews = try context.fetch(FavoriteNewsItem.fetchRequest())
        } catch {
            print("coreData error")
        }
    }
    
    func deleteFavoriteNews(item: FavoriteNewsItem) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("coreData error")
        }
    }
}
