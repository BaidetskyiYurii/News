//
//  ResponseError.swift
//  News
//
//  Created by Baidetskyi Jurii on 29.01.2023.
//

import Foundation

enum ResponseError {
    case developerError // asociated value with enum developer errors
    case repsonseError(String)
    case unknownError
    case nonAuthorized
    case processing
    case redirection
    case badRequest
    case serverError
    case noData
}
