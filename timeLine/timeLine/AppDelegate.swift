//
//  AppDelegate.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    static let navController = UINavigationController.init(rootViewController: MainController())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.navController.extendedLayoutIncludesOpaqueBars = true
        AppDelegate.navController.edgesForExtendedLayout = .all
        AppDelegate.navController.setNavigationBarHidden(true, animated: false)
        AppDelegate.navController.interactivePopGestureRecognizer?.isEnabled = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = AppDelegate.navController
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

