//
//  NewsError.swift
//  NewsApp
//
//  Created by Mert Gaygusuz on 6.09.2022.
//

import Foundation

enum NewsError: String, Error {
    case invalidData = "The data received from the server was invalid. Please try again."
    case requestLimit = "You have reached maximum request"
}
