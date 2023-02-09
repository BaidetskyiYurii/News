//
//  NewsResponce.swift
//  News
//
//  Created by Baidetskyi Jurii on 29.01.2023.
//

import Foundation

struct NewsResponce: Codable {
        let status: String
        let totalResults: Int
        let articles: [Article]?
}
