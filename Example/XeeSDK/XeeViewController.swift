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
    @IBOutlet var carIDLabel: UILabel!
    @IBOutlet var tripIDLabel: UILabel!
    @IBOutlet var deviceIDLabel: UILabel!
    
    var userID: String?
    var vehiculeID: String? {
        didSet {
            carIDLabel.text = "carID : \(vehiculeID!)"
        }
    }
    var tripID: String? {
        didSet {
            tripIDLabel.text = "tripID : \(tripID!)"
        }
    }
    var deviceID: String? {
        didSet {
            deviceIDLabel.text = "deviceID : \(deviceID!)"
        }
    }
    var privacyID: String?

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
        return 10
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
        case 4:
            cell.textLabel?.text = "Vehicle"
            break
        case 5:
            cell.textLabel?.text = "Device"
            break
        case 6:
            cell.textLabel?.text = "Get Privacies"
            break
        case 7:
            cell.textLabel?.text = "Start Privacy"
            break
        case 8:
            cell.textLabel?.text = "Stop Privacy"
            break
        case 9:
            cell.textLabel?.text = "Disconnect"
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
                        self.deviceID = vehicule.device?.deviceID!
                        self.textView.text = vehicules.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        case 4:
            if let vehicleID = vehiculeID {
                XeeRequestManager.shared.getVehicle(WithVehicleID: vehicleID, completionHandler: { (error, vehicule) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let vehicule = vehicule {
                        self.textView.text = vehicule.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        case 5:
            if let vehicleID = vehiculeID {
                XeeRequestManager.shared.getDevice(ForVehicleID: vehicleID, completionHandler: { (error, device) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let device = device {
                        self.textView.text = device.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        case 6:
            if let vehicleID = vehiculeID {
                XeeRequestManager.shared.getPrivacies(ForVehicleID: vehicleID, From: nil, To: nil, Limit: nil, completionHandler: { (error, privacies) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let privacies = privacies {
                        self.privacyID = privacies[0].privacyID
                        self.textView.text = privacies.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        case 7:
            if let vehicleID = vehiculeID {
                XeeRequestManager.shared.startPrivacy(ForVehicleID: vehicleID, completionHandler: { (error, privacy) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let privacy = privacy {
                        self.textView.text = privacy.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        case 8:
            if let privacyID = privacyID {
                XeeRequestManager.shared.stopPrivacy(ForVPrivacyID: privacyID, completionHandler: { (error, privacy) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let privacy = privacy {
                        self.textView.text = privacy.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        case 9:
            XeeConnectManager.shared.disconnect()
            break
        default:
            break
        }
    }
    
    @IBAction func edit(_ sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: "Edit", message: "Quelle est la nouvelle valeur ?", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let newID = alert.textFields?[0].text {
                switch sender.tag {
                case 1:
                    self.vehiculeID = newID
                    break
                case 2:
                    self.tripID = newID
                    break
                case 3:
                    self.deviceID = newID
                    break
                default:
                    break
                }
            }
        }))
        present(alert, animated: true, completion: nil)
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
    
    func didDisconnected() {
        self.textView.text = "Disconnected"
    }

}
