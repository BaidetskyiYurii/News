//
//  NewsManageable.swift
//  News
//
//  Created by Baidetskyi Jurii on 29.01.2023.
//

import Foundation

protocol NewsManageable {
    
    func searchNews(page: String, pageSize: String, search: String, resultHandler: @escaping (ResponseResult<NewsResponce>) -> Void)
    
}
