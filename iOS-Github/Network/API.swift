//
//  API.swift
//  iOS-Github
//
//  Created by Salim Uzun on 5.10.2021.
//

import Foundation
import Moya


enum API {
    case search(query: String, page: Int)
    case info(username: String)
    case follow(username: String)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "\(APICons.baseURL)")!
    }
    var path: String {
        switch self {
        case .search:
            return "search/users"
        case .info:
            return "users/\(UserCons.username)"
        case .follow(username: let username):
            return "user/following/\(username)"
        }
    }
    
    var method: Moya.Method {
            switch self {
            case .search, .info:
                return .get
            case .follow:
                return .put
            }
        }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .search(query: let query, page: let page):
            return .requestParameters(parameters: ["page": page, "q": query], encoding: URLEncoding.default)
        case .info(username: _):
            return .requestPlain
        case .follow(username: _):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
