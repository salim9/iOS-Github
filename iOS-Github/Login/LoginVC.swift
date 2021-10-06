//
//  ViewController.swift
//  iOS-Github
//
//  Created by Salim Uzun on 5.10.2021.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var tokenTF: UITextField!
    var viewModel: InfoViewModelProtocol = InfoViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func loginTapped(_ sender: Any) {
        if let text = usernameTF.text {
            if tokenTF.text?.count == 40 {
                UserCons.username = text
                viewModel.load(username: text)
            } else {
                showAlert(title: "Error", message: "Opps! Something is wrong with Personal Access Token :(")
            }
        }
    }
    
    func segue() {
        APICons.APIKey = tokenTF.text!
        UserCons.username = usernameTF.text!
        performSegue(withIdentifier: "loginToTab", sender: nil)
    }
    @IBAction func getTokenTapped(_ sender: Any) {
        performSegue(withIdentifier: "loginToTokenInfo", sender: nil)
    }
    
    
}

extension LoginVC: InfoViewModelDelegate {
    func reload(user: PersonalInfo) {
        segue()
    }
    
    func displayAlert(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    
}

