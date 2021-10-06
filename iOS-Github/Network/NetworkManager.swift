//
//  NetworkManager.swift
//  iOS-Github
//
//  Created by Salim Uzun on 5.10.2021.
//

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<API> { get }
    func fetchUsers(query: String, page: Int, completion: @escaping (Swift.Result<UserInfo, Error>) -> ())
    func getInfo(username: String, completion: @escaping (Swift.Result<PersonalInfo,Error>) -> ())
    func follow(username: String, completion: @escaping (Swift.Result<Any,Error>) -> ())
}

struct AuthPlugin: PluginType {
  let token: String

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
    request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    return request
  }
}

class NetworkManager: Networkable {
    
    var provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
    var tokenProvider =  MoyaProvider<API>(plugins: [NetworkLoggerPlugin(), AuthPlugin(token: APICons.APIKey)])
    
    func fetchUsers(query: String, page: Int, completion: @escaping (Swift.Result<UserInfo, Error>) -> ()) {
        request(target: API.search(query: query, page: page), completion: completion)
    }
    func getInfo(username: String, completion: @escaping (Swift.Result<PersonalInfo, Error>) -> ()) {
        request(target: API.info(username: username), completion: completion)
    }
    func follow(username: String, completion: @escaping (Swift.Result<Any, Error>) -> ()) {
        putRequest(target: API.follow(username: username), completion: completion)
    }
}

private extension NetworkManager {
    private func request<T: Decodable>(target: API, completion: @escaping (Swift.Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    print(String(describing: error))
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    private func putRequest(target: API, completion: @escaping (Swift.Result<Any, Error>) -> ()) {
        tokenProvider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    completion(.success(response.statusCode))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
