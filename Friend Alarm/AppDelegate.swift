//
//  AppDelegate.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/30/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // ViewController and TabItem setup
        let myAlarmViewController = UINavigationController(rootViewController: MyAlarmViewController())
        let friendsViewController = UINavigationController(rootViewController: FriendsViewController())
        
        let tabViewController = UITabBarController()
        tabViewController.setViewControllers([myAlarmViewController, friendsViewController], animated: false)
        tabViewController.selectedIndex = 0
        
        tabViewController.tabBar.items?[0].title = "My Alarm"
        
        self.window?.backgroundColor = UIColor.init(named: "background-color")
        self.window?.rootViewController = tabViewController
        
        self.window?.makeKeyAndVisible()
        
        // Appearance Editinngs
        UISwitch.appearance().onTintColor = UIColor(named: "alarm-red")
        UITableView.appearance().backgroundColor = .clear
        
        UINavigationBar.appearance().barTintColor = UIColor(named: "bar-color")
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "PingFangSC-Light", size: 19)!, .foregroundColor: UIColor.white]
        
        UITextField.appearance().backgroundColor = UIColor(named: "cell-color")
        UITextField.appearance().textAlignment = .center
        UITextField.appearance().textColor = UIColor(named: "tint-color")
        UITextField.appearance().tintColor = UIColor(named: "tint-color")
        UITextField.appearance().font = UIFont.init(name: "HelveticaNeue-Medium", size: 11.0)
        UITextField.appearance().borderStyle = .none
        
        UITabBar.appearance().barTintColor = UIColor(named: "bar-color")
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().isTranslucent = false 
        
        UISearchBar.appearance().barTintColor = .gray
        
        UITableViewCell.appearance().backgroundColor = UIColor(named: "cell-color")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

