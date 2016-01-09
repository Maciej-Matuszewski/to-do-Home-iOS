//
//  AppDelegate.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 05.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse
import Bolts
import SWRevealViewController
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navi: UINavigationController!
    var sw: SWRevealViewController!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId("rVJABJvv2XYeyR30JRbZwMI5lPOLVvjOwM33eZTb", clientKey: "ePancB9GZQPfcGrxPThY3qYfdGuAsHtmPZTYuqTE")
        //Parse.setApplicationId("4xyoMsSHOnqapgj0fWv6YyAbeIJvypuDeBkapKAO", clientKey: "6d9nMQwkKbxzzVKV9tlLIW3rXdTRX1BCGFixPAad")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        if(PFUser.currentUser() == nil){
            loadWelcome()
        }else{
            PFUser.currentUser()?.fetchInBackground()
            loadMain()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        application.applicationIconBadgeNumber = 0
        
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }

    func loadWelcome(){
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        
        
        let navigationController = UINavigationController.init(rootViewController: WelcomeViewController())
        navigationController.navigationBar.barStyle = UIBarStyle.Black
        navigationController.navigationBar.translucent = false
        navigationController.navigationBar.barTintColor = kColorDark
        navigationController.navigationBar.tintColor = kColorWhite
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func loadMain(){
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        let main = MainViewController()
        navi = UINavigationController.init(rootViewController: main)
        navi.navigationBar.barStyle = UIBarStyle.Black
        navi.navigationBar.translucent = false
        navi.navigationBar.barTintColor = kColorDark
        navi.navigationBar.tintColor = kColorWhite
        
        let menu = MenuViewController()
        menu.main = main
        sw = SWRevealViewController(rearViewController: menu, frontViewController: navi)
        
        window?.rootViewController = sw
        window?.makeKeyAndVisible()
    }
}

