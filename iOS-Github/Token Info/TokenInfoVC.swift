//
//  TokenInfoVC.swift
//  iOS-Github
//
//  Created by Salim Uzun on 5.10.2021.
//

import UIKit
import WebKit

class TokenInfoVC: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        webView.load(URLRequest(url: URL(string: "https://github.com/settings/tokens")!))
    }
    


}
