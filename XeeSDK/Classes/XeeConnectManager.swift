//
//  XeeConnectManager.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 03/10/2017.
//

import Foundation
import UIKit
import WebKit
import Alamofire

public protocol XeeConnectManagerDelegate: class {
    func didSuccess(token: XeeToken)
    func didFail(WithError error: Error)
    func didCancel()
    func didDisconnected()
}

public class XeeConnectManager: NSObject, WKNavigationDelegate {
    
    public override init() {}
    public static let shared = XeeConnectManager()
    public weak var delegate: XeeConnectManagerDelegate?
    
    public var config: XeeConfig?
    var embeddedWebView: WKWebView!
    var webViewSpinner: UIActivityIndicatorView?
    
    public var token: XeeToken? {
        if let tokenJSON = UserDefaults.standard.object(forKey: "XeeSDKInternalAccessToken") as? [String:Any] {
            let tokenObject: XeeToken = XeeToken(JSON: tokenJSON)!
            return tokenObject
        }else {
            return nil
        }
    }

    public var baseApiURL: String? {
        return config?.baseApiURL
    }
    
    public var baseURL: URL? {
        if let host = config?.environment?.rawValue {
            return URL(string: host)
        }else {
            return nil
        }
    }
    
    public func openURL(URL url: URL) {
        let code = getQueryStringParameter(url: url.absoluteString, param: "code")
        if let code = code {
            XeeRequestManager.shared.getToken(withCode: code, completionHandler: { (error, token) in
                self.embeddedWebView.removeFromSuperview()
                if let token = token {
                    self.delegate?.didSuccess(token: token)
                }else if let error = error {
                    self.delegate?.didFail(WithError: error)
                }
            })
        }
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func showWebView(WithURLRequest urlRequest: URLRequest) {
        self.embeddedWebView = WKWebView(frame: UIScreen.main.bounds)
        self.embeddedWebView.scrollView.bounces = false
        self.embeddedWebView.navigationDelegate = self
        if self.webViewSpinner == nil {
            self.webViewSpinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            self.webViewSpinner!.color = UIColor.black
            self.webViewSpinner!.center = self.embeddedWebView.center
        }
        self.webViewSpinner!.startAnimating()
        self.embeddedWebView.addSubview(self.webViewSpinner!)
        self.embeddedWebView.load(urlRequest)
        let cancelButton: UIButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - UIScreen.main.bounds.width / 4 - 8, y: 28, width: UIScreen.main.bounds.width / 4, height: 40))
        cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        cancelButton.setTitleColor(UIColor.init(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1.0) , for: .normal)
        cancelButton.backgroundColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.embeddedWebView.addSubview(cancelButton)
        UIApplication.shared.windows.first!.addSubview(self.embeddedWebView)
    }
    
    @objc func cancel() {
        self.embeddedWebView.removeFromSuperview()
        self.delegate?.didCancel()
    }
    
    public func createAccount() {
        showRegisterPage()
    }
    
    public func connect() {
        if token != nil {
            XeeRequestManager.shared.refreshToken(completionHandler: { (error, token) in
                if let error = error {
                    self.delegate?.didFail(WithError: error)
                }else {
                    if let token = token {
                        self.delegate?.didSuccess(token: token)
                    }else {
                        self.showAuthPage()
                    }
                }
            })
        }else {
            showAuthPage()
        }
    }
    
    public func disconnect() {
        XeeRequestManager.shared.revokeToken(completionHandler: nil)
        UserDefaults.standard.set(nil, forKey: "XeeSDKInternalAccessToken")
        UserDefaults.standard.synchronize()
        delegate?.didDisconnected()
    }
    
    func showRegisterPage() {
        
        var parameters: Parameters = [:]
        
        if let clientID = config?.clientID {
            parameters["client_id"] = clientID
        }
        if let redirectURI = config?.redirectURI {
            parameters["redirect_uri"] = redirectURI
        }
        if let host = baseURL, let scopes = config?.scopes {
            let url = URL(string: "\(host)oauth/register?scope=\(scopesURLString(WithScopes: scopes))")!
            if let urlRequest = Alamofire.request(url, parameters: parameters).request {
                showWebView(WithURLRequest: urlRequest)
            }
        }
        
    }
    
    func showAuthPage() {
        var parameters: Parameters = ["response_type":"code"]
        
        if let clientID = config?.clientID {
            parameters["client_id"] = clientID
        }
        if let redirectURI = config?.redirectURI {
            parameters["redirect_uri"] = redirectURI
        }
        if let host = baseURL, let scopes = config?.scopes {
            let url = URL(string: "\(host)oauth/authorize?scope=\(scopesURLString(WithScopes: scopes))")!
            if let urlRequest = Alamofire.request(url, parameters: parameters).request {
                showWebView(WithURLRequest: urlRequest)
            }
        }
    }
    
    func scopesURLString(WithScopes scopes: [String]) -> String {
        var scopesURL = ""
        var i: Int = 0
        for scope in scopes {
            scopesURL.append("\(scope)" + "\(i == scopes.count - 1 ? "" : "+")")
            i = i + 1
        }
        return scopesURL
    }
    
    // Hide spinner on page loaded
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let spinner = self.webViewSpinner {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
    /*
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.allHTTPHeaderFields)
        NSLog("Navigating: " + (navigationAction.request.url?.absoluteString ?? ""))
        if navigationAction.request.url != nil
        {
            let url = navigationAction.request.url
            NSLog("Host: " + (url?.host)!)
            print(navigationAction.request)
            print(url)
            print(navigationAction)
            NSLog("Path: " + url!.path)
            
            if url?.host == "app" {
                
            }
            
            if navigationAction.navigationType == .linkActivated {
                guard let url = navigationAction.request.url else {return}
                webView.load(URLRequest(url: url))
            }
        }
        
        // Default: allow navigation
        decisionHandler(.allow)
    }*/
    
    public func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        // if the request is a non-http(s) schema, then have the UIApplication handle
        // opening the request
        if let url = navigationAction.request.url,
            !url.absoluteString.hasPrefix("http://"),
            !url.absoluteString.hasPrefix("https://"),
            UIApplication.shared.canOpenURL(url) {

            // have UIApplication handle the url (sms:, tel:, mailto:, ...)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

            // cancel the request (handled by UIApplication)
            decisionHandler(.cancel)
        }
        else {
            // allow the request
            decisionHandler(.allow)
        }
    }
}
