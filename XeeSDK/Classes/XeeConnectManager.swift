//
//  XeeConnectManager.swift
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 03/10/2017.
//

import Foundation
import Alamofire

public protocol XeeConnectManagerDelegate: class {
    func didSuccess(token: XeeToken)
    func didFail(WithError error: Error)
    func didCancel()
}

public class XeeConnectManager {
    
    private init() {}
    public static let shared = XeeConnectManager()
    public weak var delegate: XeeConnectManagerDelegate?
    
    public var config: XeeConfig?
    var embeddedWebView: UIWebView!
    
    public var token: XeeToken? {
        get {
            if let tokenJSON = UserDefaults.standard.object(forKey: "XeeSDKInternalAccessToken") as? [String:Any] {
                let tokenObject: XeeToken = XeeToken(JSON: tokenJSON)!
                return tokenObject
            }else {
                return nil
            }
        }
    }
    
    public var baseURL: URL? {
        get {
            if let host = config?.environment?.rawValue {
                return URL(string: host)
            }else {
                return nil
            }
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
        self.embeddedWebView = UIWebView(frame: UIScreen.main.bounds)
        self.embeddedWebView.scrollView.bounces = false
        self.embeddedWebView.loadRequest(urlRequest)
        let cancelButton: UIButton = UIButton(frame: CGRect(x: 8, y: 28, width: UIScreen.main.bounds.width / 4, height: 40))
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
        if let token = token {
            XeeRequestManager.shared.refreshToken(withRefreshToken: token.refreshToken!, Scope: token.scope!, completionHandler: { (error, token) in
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

}
