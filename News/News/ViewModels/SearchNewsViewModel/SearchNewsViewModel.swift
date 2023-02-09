//
//  SearchNewsViewModel.swift
//  News
//
//  Created by Baidetskyi Jurii on 07.02.2023.
//

import Foundation

class SearchNewsViewModel {
    
    let networkManager: NewsManageable
    
    init(networkManager: NewsManageable = NewsManager()) {
        self.networkManager = networkManager
    }
    
    var searchResults = Bindable<NewsResponce>()
    var error = Bindable<ResponseError>()
    var page = Bindable<Int>()
    
    func searchNews(value: String, page: String, pageSize: String) {
        networkManager.searchNews(page: page, pageSize: pageSize, search: value) { [weak self] responseResult in
            switch responseResult {
            case let .success(res):
                let news = res
                DispatchQueue.main.async {
                    self?.searchResults.value = news
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self?.error.value = error
                }
            }
        }
    }
}
