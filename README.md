# Xee iOS SDK

[![Version](https://img.shields.io/cocoapods/v/XeeSDK.svg)](http://cocoapods.org/pods/XeeSDK)
[![License](https://img.shields.io/cocoapods/l/XeeSDK.svg)](http://cocoapods.org/pods/XeeSDK)
[![Platform](https://img.shields.io/cocoapods/p/XeeSDK.svg)](http://cocoapods.org/pods/XeeSDK)

This SDK make easier the usage of [Xee API](dev.xee.com) on iOS devices.
It is written in Swift

- [Example](#example)
- [Requirements](#requirements)
- [Installation](#installation)
- [Setup](#setup)
- [Authentication](#authentication)
    - [Create an account](#create-an-account)
	- [Authenticate the user](#authenticate-the-user)
	- [Disconnect the user](#disconnect-the-user)
	- [XeeConnectManagerDelegate](#xeeconnectmanagerdelegate)
- [Vehicles](#vehicles)
    - [Associate vehicle](#associate-vehicle)
	- [Retrieve users's vehicles](#retrieve-userss-vehicles)
	- [Disassociate vehicle](#disassociate-vehicle)
	- [Retrieve vehicle](#retrieve-vehicle)
    - [Update vehicle](#update-vehicle)
	- [Retrieve vehicle status](#retrieve-vehicle-status)
- [Users](#users)
    - [Retrieve users's](#retrieve-userss)
	- [Retrieve an user](#retrieve-an-user)
	- [Update an user](#update-an-user)
- [Signals](#advanced-usage)
	- [Retrieve accelerometers](#retrieve-accelerometers)
	- [Retrieves device data](#retrieves-device-data)
	- [Retrieve locations](#retrieve-locations)
	- [Retrieve signals](#retrieve-signals)
- [Privacies](#privacies)
	- [Stop a privacy](#stop-a-privacy)
	- [Retrieve privacies](#retrieve-privacies)
	- [Creates a new privacy](#creates-a-new-privacy)
- [Trips](#trips)
	- [Retrieve trip](#retrieve-trip)
	- [Retrieve trip locations](#retrieve-trip-locations)
	- [Retrieve trip signals](#retrieve-trip-signals)
	- [Retrieve vehicle status](#retrieve-vehicle-status)
- [Authorizations](#authorizations)
	- [Revoke authorization](#revoke-authorization)
	- [Retrieve users's authorizations](#retrieve-userss-authorizations)
- [Devices](#devices)
	- [Retrieve device](#retrieve-device)
	- [Retrieve pairing attempts of a device](#retrieve-pairing-attempts-of-a-device)
	- [Insert pairing attempts of a device](#insert-pairing-attempts-of-a-device)
	- [Retrieve pairings of a device](#retrieve-pairings-of-a-device)
- [Issues](#issues)
- [Author](#author)
- [License](#license)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

This SDK works for iOS with a version >= 8.0

## Installation

XeeSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XeeSDK'
```

and launch command

```ruby
pod install
```

## Setup

Create an *application* on our developer space to get credentials, see [how to create an app](https://github.com/xee-lab/xee-api-docs/tree/master/setup)

In your AppDelegate, import the SDK

```swift
import XeeSDK
```

next, in the `didFinishLaunchingWithOptions` method, create a XeeConfig object with all the informations of your app, then give it to the ConnectManager singleton :

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let xeeConfig = XeeConfig(withClientID: "<App Client ID>",
        SecretKet: "<App Secret Key>",
        Scopes: ["<App Scope list>"],
        RedirectURI: "<App Redirect URI>",
        Environment: <App Environment>)
        
    XeeConnectManager.shared.config = xeeConfig
        
    return true
}
```

Example :

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let xeeConfig = XeeConfig(withClientID: "0123456789abcdefghijklmnopqrstuvwxyz",
        SecretKet: "0123456789abcdefghijklmnopqrstuvwxyz",
        Scopes: ["account.read", "vehicles.read", "vehicles.signals.read", "vehicles.locations.read", "vehicles.trips.read"],
        RedirectURI: "xee-sdk-example://app",
        Environment: .XeeEnvironmentCLOUD)
        
    XeeConnectManager.shared.config = xeeConfig
        
    return true
}
```

You can choose the environment with the *config.environment* variable:

- XeeEnvironmentCLOUD : production environment (real client data, Authorization needed).

- XeeEnvironmentSANDBOX : sandbox environment (fake data, no Authorization needed).

then add this line in the `open url` method:

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    XeeConnectManager.shared.openURL(URL: url)
    return true
}
```

Don't forget to add the redirectURI in your URL Schemes ("xee-sdk-example", in this example) :

![alt text](https://github.com/xee-lab/xee-sdk-ios/blob/master/url_scheme.png "URL Scheme")

You're ready !

> Note that we'll keep this **SDK up to date** to provide you **all the endpoints** availables on the [4th version of the API](https://github.com/xee-lab/xee-api-docs)

## Authentication

### Create an account

Add the **XeeConnectManagerDelegate** protocol to your view controller

Call the connect method of the connectManager singleton when you want the user create an account.

```swift
XeeConnectManager.shared.delegate = self
XeeConnectManager.shared.createAccount()
```

### Authenticate the user

Add the **XeeConnectManagerDelegate** protocol to your view controller

Call the connect method of the connectManager singleton when you want the user logs in order to get a valid access token.

```swift
XeeConnectManager.shared.delegate = self
XeeConnectManager.shared.connect()
```

### Disconnect the user

Add the **XeeConnectManagerDelegate** protocol to your view controller

Call the disconnect method of the connectManager singleton when you want the user disconnect.

```swift
XeeConnectManager.shared.delegate = self
XeeConnectManager.shared.disconnect()
```

### XeeConnectManagerDelegate

Four cases:

```swift
extension YourViewController : XeeConnectManagerDelegate {
    
    func didSuccess(token: XeeToken) {
        // Success
    }
    
    func didFail(WithError error: Error) {
        // Fail
    }
    
    func didCancel() {
        // Cancel
    }
    
    func didDisconnected() {
        // Disconnected
    }
    
}
```

If there is no access token or if it's not valid, the SDK will open safari inside the application in order to authenticate with OAuth2. Once safari call back your app, the **didSuccess** method will be called.

## Vehicles

Everything about your vehicles

### Associate vehicle

Set a vehicle for an user with a specified device_id and pin code

```swift
XeeRequestManager.shared.associateVehicle(WithXeeConnectId: <XeeConnect ID>, PinCode: <Pin Code>, completionHandler: { (error, vehicle) in
    // Your code here
})
```

### Retrieve users's vehicles

Returns vehicles corresponding to specified user id

```swift
XeeRequestManager.shared.getVehicles(WithUserID: <User ID or nil for "me">, completionHandler: { (error, vehicules) in
    // Your code here
})
```

### Disassociate vehicle

Delete the pairing between a vehicle and a device

```swift
// TODO
```

### Retrieve vehicle

Returns a vehicle corresponding to specified id

```swift
XeeRequestManager.shared.getVehicle(WithVehicleID: <Vehicle ID>, completionHandler: { (error, vehicule) in
    // Your code here
})
```

### Update vehicle

Update a vehicle with a specified ID

```swift
XeeRequestManager.shared.updateVehicle(WithVehicle: <XeeVehicle object>, completionHandler: { (error, vehicle) in
    // Your code here
})
```

### Retrieve vehicle status

Returns the vehicle status of the vehicle

```swift
XeeRequestManager.shared.getStatus(WithVehicleID: <Vehicle ID>, completionHandler: { (error, status) in
    // Your code here
})
```

## Users

Access to your profile

### Retrieve an user

Returns a user corresponding to specified id, me is the current user

```swift
XeeRequestManager.shared.getUser(WithUserID: <User ID or nil for "me">, completionHandler: { (error, user) in
    // Your code here
})
```

### Update an user

Update an user with a specified ID

```swift
XeeRequestManager.shared.updateUser(WithUser: <XeeUser object>, completionHandler: { (error, user) in
    // Your code here
})
```

## Signals

Signals of Vehicles (CAN signals, GPS and Accelerometer)

### Retrieve accelerometers

Retrieves the accelerometers data of a vehicle in a given date range

```swift
// TODO
```

### Retrieves device data

Retrieves the device data of a vehicle in a given time range

```swift
// TODO
```

### Retrieve locations

Retrieves the locations of a vehicle in a given date range

```swift
// TODO
```

### Retrieve signals

Retrieves signals for a vehicle in a given date range

```swift
// TODO
```

## Privacies

Operations about privacies

### Stop a privacy

Stop an existing privacy session

```swift
XeeRequestManager.shared.stopPrivacy(ForVPrivacyID: <Privacy ID>, completionHandler: { (error, privacy) in
    // Your code here
})
```

### Retrieve privacies

Returns vehicles privacies between 2 dates inclusive

```swift
XeeRequestManager.shared.getPrivacies(ForVehicleID: <Vdehicle ID>, From: <Date or nil>, To: <Date or nil>, Limit: <Int or nil>, completionHandler: { (error, privacies) in
    // Your code here
})
```

### Creates a new privacy

Creates a new privacy session on this vehicle

```swift
XeeRequestManager.shared.startPrivacy(ForVehicleID: <Vehicle ID>, completionHandler: { (error, privacy) in
    // Your code here
})
```

## Trips

Access to the trips of the vehicles

### Retrieve trip

Returns trip corresponding to specified trip id

```swift
XeeRequestManager.shared.getTrip(WithTripID: <Trip ID>, completionHandler: { (error, trip) in
    // Your code here
})
```

### Retrieve trip locations

Returns trips locations by redirecting to the signals api with the good date range

```swift
XeeRequestManager.shared.getLocations(WithTripID: <Trip ID>, completionHandler: { (error, locations) in
    // Your code here
})
```

### Retrieve trip signals

Returns trips signals by redirecting to the signals api with the good date range

```swift
XeeRequestManager.shared.getSignals(WithTripID: <Trip ID>, completionHandler: { (error, signals) in
    // Your code here
})
```

### Retrieve vehicle trips

Returns trips corresponding to specified vehicle id. Request by date is inclusive. For example if a trip starts from 15:00 and ends at 16:00. A request from 15:15 to 15:45 will return this trip.

```swift
XeeRequestManager.shared.getTrips(WithVehicleID: <Vehicle ID>, completionHandler: { (error, trips) in
    // Your code here
})
```

## Authorizations

Manage oAuth authorizations

### Revoke authorization

Revokes the specified authorization

```swift
// TODO
```

### Retrieve users's authorizations

Returns authorizations corresponding to specified user id

```swift
// TODO
```

## Devices

Access to your device

### Retrieve device

Returns a device corresponding to specified id

```swift
// TODO
```

### Retrieve pairing attempts of a device

Returns pairings attempts corresponding to specified device id

```swift
// TODO
```

### Insert pairing attempts of a device

Inserts pairings attempts corresponding to specified device id

```swift
// TODO
```

### Retrieve pairings of a device

Returns pairings corresponding to specified device id

```swift
// TODO
```

## Issues

We're working hard to provide you an *issue free SDK*, but we're just humans so [we can do mistakes](http://i.giphy.com/RFDXes97gboYg.gif).

If you find something, feel free to [fill an issue](https://github.com/xee-lab/xee-sdk-ios/issues) or/and **fork** the repository to fix it !

## Author

Xee, jbdujardin@xee.com

## License

XeeSDK is available under the Apache License 2.0. See the [LICENSE file](LICENSE.md) for more info.
