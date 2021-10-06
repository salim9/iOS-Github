//
//  InfoVC.swift
//  iOS-Github
//
//  Created by Salim Uzun on 5.10.2021.
//

import UIKit

class InfoVC: UIViewController {
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var reposAndGistsLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    var viewModel: InfoViewModelProtocol = InfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.isHidden = true
        viewModel.delegate = self
        viewModel.load(username: UserCons.username)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func prepareImage(imageURL: URL) {
        userAvatarImageView.kf.setImage(with: imageURL) { result in
           switch result {
           case .success(let value):
               print("Image: \(value.image). Got from: \(value.cacheType)")
                break
           case .failure(let error):
               print("Error: \(error)")
           }
         }
    }

}

extension InfoVC: InfoViewModelDelegate {
    func reload(user: PersonalInfo) {
        prepareImage(imageURL: URL(string: user.avatarURL ?? "nil")!)
        usernameLabel.text = user.login
        nameLabel.text = user.name
        companyLabel.text = user.company ?? "No info"
        locationLabel.text = user.location ?? "No info"
        bioTextView.text = user.bio ?? "No info"
        followerLabel.text = "Followers: \(user.followers ?? 0)                   Following: \(user.following ?? 0)"
        reposAndGistsLabel.text = "Repos: \(user.publicRepos ?? 0)                   Gists: \(user.publicGists ?? 0)"
        stackView.isHidden = false
    }
    
    func displayAlert(title: String, message: String) {
        showAlert(title: title, message: message)
    }
}
