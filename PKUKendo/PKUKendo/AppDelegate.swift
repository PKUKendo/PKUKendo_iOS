//
//  AppDelegate.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/15/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit
import AVOSCloud

var configue:AVObject!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        application.applicationIconBadgeNumber = 0
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        application.applicationIconBadgeNumber = 0
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        AVOSCloud.setApplicationId("ql84x2woif2u3xk7p3qoska4i558v3ornikfkfga1l3ad59n", clientKey: "frzrwer3k3demoxounucm0ubfqzlvongad1h30avewweycd9")
        AVAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
       // AVPush.setProductionMode(false)
        
        application.applicationIconBadgeNumber = 0
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge | UIUserNotificationType.Alert |
            UIUserNotificationType.Sound, categories: nil))
        application.registerForRemoteNotifications()
        
        var configQ = AVQuery(className: "Configue")
        configue = configQ.getFirstObject()
        
        var currentUser = AVUser.currentUser()
        if (currentUser == nil) {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Init") as! UINavigationController
        }
        else {
            me.username = AVUser.currentUser().username
            me.nickname = AVUser.currentUser().objectForKey("NickName") as? String
            me.gender = AVUser.currentUser().objectForKey("gender") as? String
            var avartarFile = AVUser.currentUser().objectForKey("Avartar") as? AVFile
            if avartarFile != nil{
                var imgData = avartarFile?.getData()
                if imgData != nil {
                    me.avartar = UIImage(data: imgData!)
                }else {
                    if me.gender == "男"{
                        me.avartar = UIImage(named: "男生默认头像")
                    }else {
                        me.avartar = UIImage(named: "女生默认头像")
                    }
                }
//                avartarFile?.getDataInBackgroundWithBlock(){
//                    (imgData:NSData!, error:NSError!) -> Void in
//                    if(error == nil){
//                        me.avartar = UIImage(data: imgData)
//                    }
//                }
            }else {
                if me.gender == "男"{
                    me.avartar = UIImage(named: "男生默认头像")
                }else {
                    me.avartar = UIImage(named: "女生默认头像")
                }
            }
            me.password = AVUser.currentUser().password
            
            me.weixin = AVUser.currentUser().objectForKey("weixin") as? String
        }
        
        return true
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var installation = AVInstallation.currentInstallation();
        installation.setDeviceTokenFromData(deviceToken)
        var installationId:String = UIDevice.currentDevice().identifierForVendor.UUIDString
        installation.saveInBackgroundWithBlock(){
            (success:Bool, error:NSError!) -> Void in
            if success {
                println("成功inst")
            }
            else {
                println("错误\(error)")
            }
        }
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Couldn’t register: \(error)")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

