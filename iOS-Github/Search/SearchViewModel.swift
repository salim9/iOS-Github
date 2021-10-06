//
//  SearchViewModel.swift
//  iOS-Github
//
//  Created by Salim Uzun on 5.10.2021.
//

import Foundation

protocol SearchViewModelProtocol {
    var delegate: SearchViewModelDelegate? { get set }
    func load(query: String, page: Int)
    func users(_ index: Int) -> Item?
    func numberOfItems() -> Int?
    func loadNewUsers(query: String, page: Int)
}

protocol SearchViewModelDelegate: AnyObject {
    func reload()
    func prepareTableView()
    func displayAlert(title: String, message: String)
}

class SearchViewModel {
    private var networkManager = NetworkManager()
    weak var delegate: SearchViewModelDelegate?
    private var users: UserInfo?
    
    private func fetchUsers(query: String, page: Int) {
        networkManager.fetchUsers(query: query, page: page, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.users = response
                self?.delegate?.reload()
                break
            case .failure(let error):
                self?.delegate?.displayAlert(title: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
                break
            }
        })
    }
    
    private func appendNewUsers(query: String, page: Int) {
        networkManager.fetchUsers(query: query, page: page, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.users?.items.append(contentsOf: response.items)
                self?.delegate?.reload()
                break
            case .failure(let error):
                self?.delegate?.displayAlert(title: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
                break
            }
        })
    }
    
}

extension SearchViewModel: SearchViewModelProtocol {
    func numberOfItems() -> Int? {
        return users?.items.count
    }
    
    func load(query: String, page: Int) {
        delegate?.prepareTableView()
        fetchUsers(query: query, page: page)
    }
    
    func loadNewUsers(query: String, page: Int) {
        delegate?.prepareTableView()
        appendNewUsers(query: query, page: page)
    }
    
    func users(_ index: Int) -> Item? {
        return users?.items[index]
    }
}
