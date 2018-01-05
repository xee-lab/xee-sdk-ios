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

        let xeeConfig = XeeConfig(withClientID: "44bf462b8603c15b845832b05b1e61c2",
                                  SecretKet: "5942ff562201e4300ab9fc973fb4f0d56bacd294fc17d508959bc0bb99bfd827",
                                  Scopes: ["account.management", "account.read", "vehicles.accelerometers.read", "vehicles.management", "vehicles.read", "vehicles.signals.read", "vehicles.trips.read", "vehicles.locations.read"],
                                  RedirectURI: "xeekit-staging://app",
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

