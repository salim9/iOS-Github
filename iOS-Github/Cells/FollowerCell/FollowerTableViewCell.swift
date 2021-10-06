//
//  FollowerTableViewCell.swift
//  iOS-Github
//
//  Created by Salim Uzun on 5.10.2021.
//

import UIKit
import Kingfisher

protocol FollowerCell {
    var delegate: FollowerCellDelegate? { get set }
}

protocol FollowerCellDelegate: AnyObject {
    func disable(index: Int)
    func displayAlert(title: String, message: String)
    func errorAlert()
}

class FollowerTableViewCell: UITableViewCell, FollowerCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    weak var delegate: FollowerCellDelegate?
    private var networkManager = NetworkManager()
    var indexPath: Int!
    
    func configure(image: URL, username: String, indexPath: Int) {
            usernameLabel.text = username
            preparePosterImage(imageURL: image)
            self.indexPath = indexPath
        }
        
        func preparePosterImage(imageURL: URL) {
            posterImage.kf.setImage(with: imageURL) { result in
               switch result {
               case .success(let value):
                   print("Image: \(value.image). Got from: \(value.cacheType)")
                    break
               case .failure(let error):
                   print("Error: \(error)")
               }
             }
        }

    @IBAction func followAction(_ sender: Any) {
        networkManager.follow(username: usernameLabel.text ?? "", completion: { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let response):
                if (response as! Int > 299) {
                    self?.delegate?.errorAlert()
                } else {
                    self?.delegate?.disable(index: (self?.indexPath!)!)
                }
                break
            case .failure(let error):
                self?.delegate?.displayAlert(title: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
                break
            }
        })
    }
    
}
