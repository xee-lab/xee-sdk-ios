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
    @IBOutlet var userIDLabel: UILabel!
    @IBOutlet var carIDLabel: UILabel!
    @IBOutlet var tripIDLabel: UILabel!
    @IBOutlet var deviceIDLabel: UILabel!
    
    var userID: String? {
        didSet {
            userIDLabel.text = "userID : \(userID!)"
        }
    }
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
        return 16
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
            cell.textLabel?.text = "Update User"
            break
        case 4:
            cell.textLabel?.text = "Vehicles"
            break
        case 5:
            cell.textLabel?.text = "Vehicle"
            break
        case 6:
            cell.textLabel?.text = "Vehicle Status"
            break
        case 7:
            cell.textLabel?.text = "Update Vehicle"
            break
        case 8:
            cell.textLabel?.text = "Device"
            break
        case 9:
            cell.textLabel?.text = "Get Privacies"
            break
        case 10:
            cell.textLabel?.text = "Start Privacy"
            break
        case 11:
            cell.textLabel?.text = "Stop Privacy"
            break
        case 12:
            cell.textLabel?.text = "Trips"
            break
        case 13:
            cell.textLabel?.text = "Trip"
            break
        case 14:
            cell.textLabel?.text = "Trip Signals"
            break
        case 15:
            cell.textLabel?.text = "Disconnect"
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        // Create Account
        case 0:
            XeeConnectManager.shared.delegate = self
            XeeConnectManager.shared.createAccount()
            break
        // Connect
        case 1:
            XeeConnectManager.shared.delegate = self
            XeeConnectManager.shared.connect()
            break
        // User/me
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
        // Update User
        case 3:
            XeeRequestManager.shared.getUser(completionHandler: { (error, user) in
                if let user = user {
                    let temp = user.firstName
                    user.firstName = "TEST"
                    XeeRequestManager.shared.updateUser(WithUser: user, completionHandler: { (error, user) in
                        if let error = error {
                            self.textView.text = error.localizedDescription
                        }else if let user = user {
                            self.textView.text = user.toJSONString(prettyPrint: true)
                            user.firstName = temp
                            XeeRequestManager.shared.updateUser(WithUser: user, completionHandler: nil)
                        }
                    })
                }
            })
            break
        // Get Vehicles
        case 4:
            XeeRequestManager.shared.getVehicles(WithUserID: nil, completionHandler: { (error, vehicules) in
                if let error = error {
                    self.textView.text = error.localizedDescription
                }else if let vehicules = vehicules {
                    let vehicule = vehicules[0]
                    self.vehiculeID = vehicule.vehiculeID!
                    self.deviceID = vehicule.device?.deviceID!
                    self.textView.text = vehicules.toJSONString(prettyPrint: true)
                }
            })
            break
        // Get Vehicule by ID
        case 5:
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
        // Get Vehicle Status
        case 6:
            if let vehicleID = vehiculeID {
                XeeRequestManager.shared.getStatus(WithVehicleID: vehicleID, completionHandler: { (error, status) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let status = status {
                        self.textView.text = status.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        // Update vehicle
        case 7:
            if let vehicleID = vehiculeID {
                XeeRequestManager.shared.getVehicle(WithVehicleID: vehicleID, completionHandler: { (error, vehicle) in
                    if let vehicle = vehicle {
                        let temp = vehicle.name
                        vehicle.name = "TEST"
                        XeeRequestManager.shared.updateVehicle(WithVehicle: vehicle, completionHandler: { (error, vehicle) in
                            if let error = error {
                                self.textView.text = error.localizedDescription
                            }else if let vehicle = vehicle {
                                self.textView.text = vehicle.toJSONString(prettyPrint: true)
                                vehicle.name = temp
                                XeeRequestManager.shared.updateVehicle(WithVehicle: vehicle, completionHandler: nil)
                            }
                        })
                    }
                })
            }
            break
        // Get Vehicle Device
        case 8:
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
        // Get Vehicle Privacies
        case 9:
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
        // Start Privacy
        case 10:
            if let vehicleID = vehiculeID {
                XeeRequestManager.shared.startPrivacy(ForVehicleID: vehicleID, completionHandler: { (error, privacy) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let privacy = privacy {
                        self.privacyID = privacy.privacyID
                        self.textView.text = privacy.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        // Stop Privacy
        case 11:
            if let privacyID = privacyID {
                XeeRequestManager.shared.stopPrivacy(ForVPrivacyID: privacyID, completionHandler: { (error, privacy) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let privacy = privacy {
                        self.textView.text = privacy.toJSONString(prettyPrint: true)
                    }
                })
            }else {
                self.textView.text = "No privacy created"
            }
            break
        // Vehicle Trips
        case 12:
            if let vehicleID = vehiculeID {
                XeeRequestManager.shared.getTrips(WithVehicleID: vehicleID, completionHandler: { (error, trips) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let trips = trips {
                        self.tripID = trips[0].tripID
                        self.textView.text = trips.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        // Vehicle Trip
        case 13:
            if let tripID = tripID {
                XeeRequestManager.shared.getTrip(WithTripID: tripID, completionHandler: { (error, trip) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let trip = trip {
                        self.textView.text = trip.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        // Trip Signals
        case 14:
            if let tripID = tripID {
                XeeRequestManager.shared.getSignals(WithTripID: tripID, completionHandler: { (error, signals) in
                    if let error = error {
                        self.textView.text = error.localizedDescription
                    }else if let signals = signals {
                        self.textView.text = signals.toJSONString(prettyPrint: true)
                    }
                })
            }
            break
        // Disconnect
        case 15:
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
                    self.userID = newID
                    break
                case 2:
                    self.vehiculeID = newID
                    break
                case 3:
                    self.tripID = newID
                    break
                case 4:
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
