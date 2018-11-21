//
//  ViewController.swift
//  IvanovIgor_VK
//
//  Created by Igor Ivanov on 23.09.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var webview: WKWebView! {
        didSet{
            webview.navigationDelegate = self
        }
    }
    
    
    var presenter: PresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6747409"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.87")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webview.load(request)
    }
    
    private func setupPresenter(completion: (()->Void)?){
        presenter = Configurator.shared.preloadPresenter(for: String(describing: FriendsController.self),
                                                         loadType: .diskFirst,
                                                         completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true // Задание 6.1: анимация
//        if login == "admin" && password == "123456" {
//            return true
//        } else {
//            let alter = UIAlertController(title: "Ошибка", message: "Введены неверные данные пользователя", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alter.addAction(action)
//            present(alter, animated: true, completion: nil)
//
//            return false
//        }
    }
    
}



extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment
            else {
                    decisionHandler(.allow)
                    return
            }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        print(params)
        
        guard let token = params["access_token"], let userId = Int(params["user_id"]!) else {
            decisionHandler(.cancel)
            return
        }
        
        print(token, userId)
        Session.shared.token = token
        Session.shared.userId = userId
        setupPresenter(){ [weak self] in
            self?.performSegue(withIdentifier: "ShowMainSegue", sender: nil)
        }
        decisionHandler(.cancel)
        
    }
}
