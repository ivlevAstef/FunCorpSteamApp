//
//  AppDelegate.swift
//  ApLife
//
//  Created by Alexander Ivlev on 22/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppStartPoint.configure()
        log.info("configuration finished")
        AppStartPoint.reg()
        log.info("registration and validate dependency finished")
        AppStartPoint.initialize()
        log.info("initialize modules finished")

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        AppStartPoint.app.configureWindow(window)
        AppStartPoint.app.start(launchOptions: launchOptions)
        window.makeKeyAndVisible()

        log.info("setup windows and started application")
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return AppStartPoint.app.openUrl(url)
    }
}

