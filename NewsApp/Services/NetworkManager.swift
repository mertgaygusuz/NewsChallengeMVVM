//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Mert Gaygusuz on 6.09.2022.
//

import UIKit

enum ListType {
    case search
    case listHeadlines
}

final class NetworkManager {
    
    private let baseURL = "https://newsapi.org/v2"
    private let apiKey = "d0c0635a25a246578cbb644ffc94f786"
    

    func getNews(keyWords: String, page: Int, type: ListType, completionHandler: @escaping (Result<[Articles], NewsError>) -> Void) {
        let searchEndPoint = "\(baseURL)/everything?q=\(keyWords)&page=\(page)&apiKey=\(apiKey)"
        let headlinesEndPoint = "\(baseURL)/top-headlines?country=US&apiKey=\(apiKey)"
        
        let stringForUrl = type == .listHeadlines ? headlinesEndPoint : searchEndPoint
        
        guard let url = URL(string: stringForUrl) else {
            completionHandler(.failure(.invalidData))
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error == nil && data != nil {
                let decoder = JSONDecoder()

                do {
                    let news = try decoder.decode(NewsModel.self, from: data!)
                    if news.status == "error" {
                        completionHandler(.failure(.requestLimit))
                    }
                    completionHandler(.success(news.articles))

                } catch {
                    completionHandler(.failure(.invalidData))
                }

            }
        }
        dataTask.resume()
    }
}

