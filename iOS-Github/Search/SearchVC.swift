//
//  SearchVC.swift
//  iOS-Github
//
//  Created by Salim Uzun on 5.10.2021.
//

import UIKit

class SearchVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
                searchBar.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView!
    var cellModel: FollowerCell = FollowerTableViewCell()
    var viewModel: SearchViewModelProtocol = SearchViewModel()
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellModel.delegate = self
        viewModel.delegate = self
        tableView.isHidden = true
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            startLoading()
            viewModel.load(query: query, page: 1)
        }
    }
}


extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellConstants.reuseIdentifier, for: indexPath as IndexPath) as? FollowerTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        if let users = viewModel.users(indexPath.item) {
            let posterImage = users.avatarURL ?? "nil"
            cell.configure(image: URL(string: posterImage)!, username: users.login ?? "No Info", indexPath: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == viewModel.numberOfItems() && indexPath.row + 1 > 9) {
            startLoading()
            page = page + 1
            viewModel.loadNewUsers(query: searchBar.text ?? "", page: page)
        }
        stopLoading()
    }
    
}

extension SearchVC: SearchViewModelDelegate {
    func displayAlert(title: String, message: String) {
        showAlert(title: title, message: message)
        stopLoading()
    }
    
    func prepareTableView() {
        stopLoading()
        tableView.register(UINib(nibName: String(describing: FollowerTableViewCell.self), bundle: nil), forCellReuseIdentifier: CellConstants.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reload() {
        tableView.reloadData()
        tableView.isHidden = false
    }
}

extension SearchVC: FollowerCellDelegate {
    func disable(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        let tableViewCell = tableView.cellForRow(at: indexPath) as! FollowerTableViewCell
        tableViewCell.followButton.isEnabled = false
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Error", message: "Oops! Somethings is wrong with your username/token.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
            if let secondVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
                self.navigationController?.pushViewController(secondVc, animated: true)
            }
        }))

        self.present(alert, animated: true)
    }
}
