//
//  AppDelegate.swift
//  CoreDataCRUD
//
//  Created by Thomas Woodfin on 7/4/18.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.sharedManager.saveContext()
    }
}

