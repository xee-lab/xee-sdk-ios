//
//  AppDelegate.swift
//  XeeSDK
//
//  Created by jbdujardin on 10/02/2017.
//  Copyright (c) 2017 jbdujardin. All rights reserved.
//

import UIKit
import XeeSDK
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        NetworkActivityIndicatorManager.shared.isEnabled = true

        let xeeConfig = XeeConfig(withClientID: "c30a2cd5c0a4ac3483388002e45b26a8",
                                  SecretKet: "73be86bc2c42e63bc9bc8184692a8667c9ffd289628f824725cd8d71b925fc8e",
                                  Scopes: ["account.read", "account.management", "vehicles.read", "vehicles.management", "vehicles.privacies.read", "vehicles.signals.read", "vehicles.locations.read", "vehicles.privacies.management", "vehicles.trips.read"],
                                  RedirectURI: "xee-sdk-example://app",
                                  Environment: .XeeEnvironmentSTAGING)
        
        XeeConnectManager.shared.config = xeeConfig
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        XeeConnectManager.shared.openURL(URL: url)
        return true
    }

}

