//
//  InfoViewModel.swift
//  iOS-Github
//
//  Created by Salim Uzun on 5.10.2021.
//

import Foundation

protocol InfoViewModelProtocol {
    var delegate: InfoViewModelDelegate? { get set }
    func load(username: String)
}

protocol InfoViewModelDelegate: AnyObject {
    func reload(user: PersonalInfo)
    func displayAlert(title: String, message: String)
}

class InfoViewModel {
    private var networkManager = NetworkManager()
    weak var delegate: InfoViewModelDelegate?
    private var user: PersonalInfo?
    
    private func getInfo(username: String) {
        networkManager.getInfo(username: username, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.user = response
                self?.delegate?.reload(user: strongSelf.user!)
                break
            case .failure(let error):
                self?.delegate?.displayAlert(title: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
                break
            }
        })
    }
}

extension InfoViewModel: InfoViewModelProtocol {
    func load(username: String) {
        getInfo(username: username)
    }
}
