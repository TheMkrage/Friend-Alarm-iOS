//
//  AppDelegate.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/30/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import UserNotifications
import AVKit
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        UIApplication.shared.statusBarStyle = .lightContent
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print(fileURLs)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        // ViewController and TabItem setup
        let myAlarmViewController = UINavigationController(rootViewController: MyAlarmViewController())
        let friendsViewController = UINavigationController(rootViewController: FriendsViewController())
        
        let tabViewController = UITabBarController()
        tabViewController.setViewControllers([myAlarmViewController, friendsViewController], animated: false)
        tabViewController.selectedIndex = 0
        
        tabViewController.tabBar.items?[0].title = "My Alarm"
        tabViewController.tabBar.items?[1].title = "Friends"
        
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
        
        UISearchBar.appearance().tintColor = UIColor(named: "tint-color")
        UISearchBar.appearance().backgroundColor = UIColor(named: "cell-color")
        
        UITabBar.appearance().barTintColor = UIColor(named: "bar-color")
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().isTranslucent = false 
        
        UISearchBar.appearance().barTintColor = .gray
        
        UITableViewCell.appearance().backgroundColor = UIColor(named: "cell-color")
        
        
        /*let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
            print("we did it")
        }
 */
        self.registerForPushNotifications()
        
        return true
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                //print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            // Fallback on earlier versions
        }
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
        AlarmPlayer.shared.stop()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("app delegate sees notification")
        if application.applicationState == .background, let id = userInfo["id"] as? Int, AlarmStore.shared.isAlarmSet(), let isSecond = userInfo["isSecond"] as? Bool {
            if isSecond {
                if UserDefaults.standard.bool(forKey: "needsToAlarm") {
                    UserDefaults.standard.setValue(false, forKey: "needsToAlarm")
                    AlarmPlayer.shared.playAlarm(id: id, remoteUrl: userInfo["url"] as? String)
                }
            } else {
                AlarmPlayer.shared.playAlarm(id: id, remoteUrl: userInfo["url"] as? String)
            }
        }
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        let currentStoredToken = UserDefaults.standard.string(forKey: "token")
        // if user exists, and this key is different from one stored on disk
        
        if token != currentStoredToken {
            UserDefaults.standard.set(token, forKey: "token")
        }
    }
}
