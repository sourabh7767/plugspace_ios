//
//  InstagramVC.swift
//  PlugSpace
//
//  Created by MAC on 16/12/21.
//

import UIKit
import WebKit
import Alamofire

class InstagramVC: BaseVC {
    
    //MARK:- Outlets
    
    @IBOutlet weak var instaWebView:WKWebView!
    
    //MARK:- Properties
      
    let viewLoginModel = LoginVM()
    private let viewModel = SignUPVM()
    var isLogin = false
    
    //MARK:-
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
        loginWithInsta()
        instaWebView.scrollView.delegate = self
        instaWebView.scrollView.bounces = false
        instaWebView.scrollView.bouncesZoom = false
        instaWebView.scrollView.alwaysBounceVertical = false
        instaWebView.scrollView.alwaysBounceHorizontal = false
    }
    // Do any additional setup after loading the view.

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    
        IndicatorManager.hideLoader()
    
    }

    //MARK:- Method
    
    func setupUI() {
      
    }
    
    func loginWithInsta() {
        
        IndicatorManager.showLoader()
        AppDelegate.shared.clearCache()
        instaWebView.navigationDelegate = self
        viewModel.delegate = self
        let client_id = INSTA_APP_ID
        let redirect_url = INSTA_REDIRECT_URL
        let url = "https://instagram.com/oauth/authorize/?client_id=\(client_id)&redirect_uri=\(redirect_url)&response_type=code&scope=user_profile"
        if let reqURl = URL(string: url) {
            let req = URLRequest(url: reqURl)
            instaWebView.load(req)
        }
    }
    
    //MARK:- IBAction
    
    @IBAction private func onBtnInsta(_ sender: UIButton) {
        self.view.endEditing(true)
       
    }
    
    @IBAction private func onBtnInstaCancel(_ sender: UIButton) {
      
        backVC()
        AppDelegate.shared.clearCache()

    }
    
    //MARK:- Method
}

//MARK:-   WKNavigationDelegate


extension InstagramVC: WKNavigationDelegate,UIScrollViewDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        IndicatorManager.hideLoader()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        IndicatorManager.hideLoader()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        
        guard let url = webView.url else { return }
        
        if url.absoluteString.contains("instagram") {
            let response = navigationResponse.response as? HTTPURLResponse
            
            if let res = response?.headers {
                let url = res["Refresh"]
                let code = url?.components(separatedBy: "code=").last?.components(separatedBy: "#_").first
                
                if code != nil {
                    let urlString = "https://api.instagram.com/oauth/access_token"
                    let client_id = INSTA_APP_ID
                    let redirect_url = INSTA_REDIRECT_URL
                    let app_secret = INSTA_APP_CLIENT_SECRET
                    let param = ["client_id" : client_id,
                                 "client_secret" : app_secret,
                                 "grant_type" : "authorization_code",
                                 "redirect_uri" :redirect_url,
                                 "code" : code!]
                    
                    IndicatorManager.showLoader()
                    
                    AF.request(urlString, method: .post, parameters: param).responseJSON { [self] (response) in
                        
                        guard response.error == nil else {
                            IndicatorManager.hideLoader()
                            self.alertWith(message: response.error?.localizedDescription ?? "")
                            return
                        }
                        if let res = response.value as? [String:Any] {
                            let accessToken = res["access_token"] as? String ?? ""
                            let userId = res["user_id"] as? Int ?? 0
                            
                            let finalURl = "https://graph.instagram.com/" + "\(userId)" + "?fields=id,username&access_token=" + accessToken
                            
                            AF.request(finalURl, method: .get).responseJSON { (response) in
                                IndicatorManager.hideLoader()
                                guard response.error == nil else {
                                    self.alertWith(message: response.error?.localizedDescription ?? "")
                                    return
                                }
                                
                                if let res = response.value as? [String:Any] {
                                    
                                    if self.isLogin {
                                        self.viewLoginModel.isInsta = "1"
                                        self.viewLoginModel.instaId = res["id"] as? String ?? ""
                                        self.viewLoginModel.isApple = "0"
                                        self.viewLoginModel.appleId = "0"
                                    } else {
                                        self.viewModel.isApple = "0"
                                        self.viewModel.appleId = "0"
                                        self.viewModel.isInsta = "1"
                                        self.viewModel.instaId = res["id"] as? String ?? ""
                                    }
                                    self.backVC()
                                    self.isLogin ? self.viewModel.delegate?.instaLoginProcessCompleted(isSuccess: true) : self.viewModel.delegate?.instaSignupProcessCompleted(isSuccess: true)
                                    
//                                    self.userModel.username = res["username"] as? String ?? ""
//                                    self.userModel.socialMediaUrl =                                                                       "https://www.instagram.com/\(self.userModel.username ?? "")/"
                                    //AppPrefsManager.shared.setIsUserLogin(isUserLogin: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        // guard let url = webView.url else { return }
    }
}

extension InstagramVC: SignUpVMDelegate {
    
    func instaSignupProcessCompleted(isSuccess: Bool) {
        if isSuccess {
            pushVC(GenderVC.self)
        } else {
            self.alertWith(message: viewModel.errorMessage)
        }
    }
    
    func instaLoginProcessCompleted(isSuccess: Bool) {
        self.view.endEditing(true)
        if isSuccess {
            
            viewLoginModel.isRegister { [self] (isSuccess) in
                
                if isSuccess {
                    self.successAlert(AppName, message: viewLoginModel.errorMessage, button: "OK") {
                        appdelegate.goToHomeVc()
                        AppPrefsManager.shared.setIsUserLogin(isUserLogin: true)
                    }
                }else {
                    alertWith(message: viewLoginModel.errorMessage)
                }
            }
        } else {
            self.alertWith(message: viewLoginModel.errorMessage)
        }
    }
}
