//
//  NewsManager.swift
//  News
//
//  Created by Baidetskyi Jurii on 29.01.2023.
//

import Foundation

final class NewsManager: NewsManageable {
   
    private var networkManager: NetworkManageable
    
    init() {
        networkManager = NetworkManager()
    }
    
    func searchNews(page: String, pageSize: String, search: String, resultHandler: @escaping (ResponseResult<NewsResponce>) -> Void) {
        let type = NewsMethods.search(search, page, pageSize)
        networkManager.loadRequest(methodPath: type.methodPath,
                                   methodType: type.methodType,
                                   queryParams: type.queryParams,
                                   bodyParams: type.bodyParams,
                                   resultHandler: resultHandler)
    }
    
}

extension NewsManager {
    
    enum NewsMethods {
        case search(String, String, String)
        
        var methodPath: String {
            switch self {
            case .search:
                return "/v2/everything"
            }
        }
        var methodType: String {
            return "GET"
        }
       
        var queryParams: [String: String]? {
            switch self {
            case let .search(value,page,pageSize):
                return ["q":value, "page":page, "pageSize": pageSize, "sortBy":"publishedAt"]
            }
        }
        
        var bodyParams: [String: AnyObject]? {
            switch self {
            default: return nil
            }
        }
    }
}
