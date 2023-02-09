//
//  NetworkManageable.swift
//  News
//
//  Created by Baidetskyi Jurii on 29.01.2023.
//

import Foundation

protocol NetworkManageable {
    var baseURL: String { get }
    func loadRequest<T: Codable>(methodPath: String,
                                 methodType: String,
                                 queryParams: [String: String]?,
                                 bodyParams: [String: Any]?,
                                 resultHandler: @escaping(_ result: ResponseResult<T>) -> Void
    )
}
