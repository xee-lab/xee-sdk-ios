//
//  XeeViewController.swift
//  XeeSDK_Example
//
//  Created by Jean-Baptiste Dujardin on 03/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import XeeSDK

class XeeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XeeConnectManagerDelegate {
    
    @IBOutlet var textView: UITextView!
    
    var userID: String?
    var vehiculeID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Create Account"
            break
        case 1:
            cell.textLabel?.text = "Connect"
            break
        case 2:
            cell.textLabel?.text = "Users/me"
            break
        case 3:
            cell.textLabel?.text = "Vehicles"
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            XeeConnectManager.shared.delegate = self
            XeeConnectManager.shared.createAccount()
            break
        case 1:
            XeeConnectManager.shared.delegate = self
            XeeConnectManager.shared.connect()
            break
        case 2:
            XeeRequestManager.shared.getUser(completionHandler: { (error, user) in
                if let error = error {
                    self.textView.text = error.localizedDescription
                }else if let user = user {
                    self.userID = user.userID
                    self.textView.text = user.toJSONString(prettyPrint: true)
                }
            })
            break
        case 3:
            if let userID = userID {
                XeeRequestManager.shared.getVehicles(WithUserID: userID, completionHandler: { (error, vehicules) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let vehicules = vehicules {
                        let vehicule = vehicules[0]
                        self.vehiculeID = vehicule.vehiculeID!
                        self.textView.text = vehicules.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        default:
            break
        }
    }
    
    // MARK: - XeeConnectManagerDelegate
    
    func didSuccess(token: XeeToken) {
        self.textView.text = token.toJSONString(prettyPrint: true)
    }
    
    func didFail(WithError error: Error) {
        self.textView.text = error.localizedDescription
    }
    
    func didCancel() {
        self.textView.text = "Canceled"
    }

}
