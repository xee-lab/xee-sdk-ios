# XeeSDK

[![Version](https://img.shields.io/cocoapods/v/XeeSDK.svg?style=flat)](http://cocoapods.org/pods/XeeSDK)
[![License](https://img.shields.io/cocoapods/l/XeeSDK.svg?style=flat)](http://cocoapods.org/pods/XeeSDK)
[![Platform](https://img.shields.io/cocoapods/p/XeeSDK.svg?style=flat)](http://cocoapods.org/pods/XeeSDK)

## Purpose

This SDK make easier the usage of [Xee API](dev.xee.com) on iOS devices !

It is written in Objective-C

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

This SDK works for iOS with a version >= 8.0

## Installation

XeeSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "XeeSDK"
```

## Setup

Create an *application* on our developer space to get credentials, see [how to create an app](https://github.com/xee-lab/xee-api-docs/tree/master/setup)

In your AppDelegate, import the SDK

```{objectivec}
@import XeeSDK;
```

next, in the `didFinishLaunchingWithOptions` method, create a XeeConfig object with all the informations of your app, then give it to the setConfig method of the connectManager object:

```{objectivec}
XeeConfig *config = [[XeeConfig alloc] init];
config.secretKey = @"6xEj7PAIDOChvOkTAcGH";
config.clientID = @"5IOeWDhCzg93QYM1jFBz";
config.redirectURI = @"myapp://";
config.environment = XeeEnvironmentCLOUD;
[[Xee connectManager] setConfig:config];
```

You can choose the environment with the *config.environment* variable:

- XeeEnvironmentCLOUD : production environment (real client data, Authorization needed).

- XeeEnvironmentSANDBOX : sandbox environment (fake data, no Authorization needed).

then add this line in the `openURL` method:

```{objectivec}
[[Xee connectManager] openURL:url];
```

Don't forget to add the redirectURI in your URL Schemes ("myapp", in this example).

You're ready !

## Usage

Here are some example of commons methods you might use.

> Note that we'll keep this **SDK up to date** to provide you **all the endpoints** availables on the [3rd version of the API](https://github.com/xee-lab/xee-api-docs/tree/master/api/api/v3)

### Authenticate the user

Add the **XeeConnectManagerDelegate** protocol to your view controller

Call the connect method of the connectManager object when you want the user logs in order to get a valid access token.

```{objectivec}
[Xee connectManager].delegate = self;
[[Xee connectManager] connect];
```
Two cases:

If the SDK already have a valid access token, the delegate will call the method:

```{objectivec}
-(void)connectManager:(XeeConnectManager*)connectManager didSuccess:(XeeAccessToken*)accessToken;
```

If there is no access token or if it's not valid, the SDK will open safari inside the application in order to authenticate with OAuth2. Once safari call back your app, the **connectManager:didSuccess:** method will be called.

### Get the cars of the user

```{objectivec}
[[Xee requestManager].users meCars:^(NSArray<XeeCar *> *cars, NSArray<XeeError *> *errors) {
    if(!errors) {
        NSLog(@"%@", cars);
    } else {
        NSLog(@"%@", errors);
    }
}];
```

### Get the trips of the car

```{objectivec}
[[Xee requestManager].cars tripsWithCarId:482 begin:[NSDate dateWithTimeIntervalSinceNow:-3600*24*7] end:nil completionHandler:^(NSArray<XeeTrip *> *trips, NSArray<XeeError *> *errors) {
    if(!errors) {
        NSLog(@"%@", trips);
    } else {
        NSLog(@"%@", errors);
    }
}];
```

### Get the locations of the car

```{objectivec}
[[Xee requestManager].cars locationsWithCarId:482 limit:0 begin:[NSDate dateWithTimeIntervalSinceNow:-3600*10] end:nil completionHandler:^(NSArray<XeeLocation *> *locations, NSArray<XeeError *> *errors) {
    if(!errors) {
        NSLog(@"%@", locations);
    } else {
        NSLog(@"%@", errors);
    }
}];
```

### Get the signals of the car

```{objectivec}
[[Xee requestManager].cars signalsWithCarId:482 limit:0 begin:[NSDate dateWithTimeIntervalSinceNow:-3600*10] end:nil name:@[@"VehiculeSpeed"] completionHandler:^(NSArray<XeeSignal *> *signals, NSArray<XeeError *> *errors) {
    if(!errors) {
        NSLog(@"%@", signals);
    } else {
        NSLog(@"%@", errors);
    }
}];
```

## Issues

We're working hard to provide you an *issue free SDK*, but we're just humans so [we can do mistakes](http://i.giphy.com/RFDXes97gboYg.gif).

If you find something, feel free to [fill an issue](https://github.com/xee-lab/xee-sdk-ios/issues) or/and **fork** the repository to fix it !

## Author

Eliocity, jbdujardin@xee.com

## License

XeeSDK is available under the Apache License 2.0. See the LICENSE file for more info.
