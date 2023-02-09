//
//  NewsModel.swift
//  News
//
//  Created by Baidetskyi Jurii on 29.01.2023.
//

import Foundation

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let urlToImage: String?
    let url: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}

enum ID: String, Codable {
    case businessInsider = "business-insider"
    case reuters = "reuters"
}
