//
//  esponceResult.swift
//  News
//
//  Created by Baidetskyi Jurii on 29.01.2023.
//

import Foundation

enum ResponseResult<T: Codable> {
    case success(T)
    case failure(ResponseError)
}
