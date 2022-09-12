//
//  NewsModel.swift
//  NewsApp
//
//  Created by Mert Gaygusuz on 6.09.2022.
//

import Foundation

struct NewsModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [Articles]
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case articles = "articles"
        case totalResults = "totalResults"
    }
}

struct Articles: Codable {
    let author: String?
    let title: String?
    let description: String?
    let publishDate: String?
    let content: String?
    let image: String?
    let urlLink: String?
    
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case title = "title"
        case description = "description"
        case publishDate = "publishedAt"
        case content = "content"
        case image = "urlToImage"
        case urlLink = "url"
    }
}



 
