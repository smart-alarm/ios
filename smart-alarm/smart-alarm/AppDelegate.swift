//
//  AppDelegate.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 9/30/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let ALARMS_KEY = "alarmItems"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        /* FABRIC IO */
        Fabric.with([Crashlytics.self()])
        
        /* REGISTER NOTIFICATION ACTIONS */
        
        // AWAKE ACTION
        let awakeAction = UIMutableUserNotificationAction()
        awakeAction.identifier = "AWAKE_ACTION" // the unique identifier for this action
        awakeAction.title = "Ok, I'm up!" // title for the action button
        awakeAction.activationMode = .Background // UIUserNotificationActivationMode.Background - don't bring app to foreground
        awakeAction.authenticationRequired = false // don't require unlocking before performing action
        awakeAction.destructive = true // display action in red
        
        // ALARM CATEGORY
        let alarmCategory = UIMutableUserNotificationCategory()
        alarmCategory.identifier = "ALARM_CATEGORY"
        alarmCategory.setActions([awakeAction], forContext: .Default)
        alarmCategory.setActions([awakeAction], forContext: .Minimal)
        
        // ARRIVE ACTION
        let arriveAction = UIMutableUserNotificationAction()
        arriveAction.identifier = "ARRIVE_ACTION"
        arriveAction.title = "Yes! I've arrived."
        arriveAction.activationMode = .Background
        arriveAction.authenticationRequired = false
        arriveAction.destructive = false
        
        // LATE ACTION
        let lateAction = UIMutableUserNotificationAction()
        lateAction.identifier = "LATE_ACTION"
        lateAction.title = "No, I'm late"
        lateAction.activationMode = .Background
        lateAction.authenticationRequired = false
        lateAction.destructive = true
        
        // FOLLOWUP CATEGORY
        let followupCategory = UIMutableUserNotificationCategory()
        followupCategory.identifier = "FOLLOWUP_CATEGORY"
        followupCategory.setActions([arriveAction, lateAction], forContext: .Default)
        followupCategory.setActions([arriveAction, lateAction], forContext: .Minimal)
        
        // REGISTER NOTIFICATIONS
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: [alarmCategory, followupCategory]))
        return true
    }
    
    /* HANDLE NOTIFICATION ACTIONS */
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        switch (identifier!) {
        case "AWAKE_ACTION":
            print("APP DELEGATE: AWAKE_ACTION")
            break
        case "ARRIVE_ACTION":
            print("APP DELEGATE: ARRIVE_ACTION")
            // TODO: HTTP POST {deviceUUID, arrivalTime, didArrive = TRUE}
            
            let alarmDictionary: NSDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey("alarmItems") ?? Dictionary()
            let alarmID = notification.userInfo!["UUID"] as! String
            let alarm = alarmDictionary.valueForKey(alarmID)
            
            let dataDictionary: NSDictionary = [
                "deviceUUID": UIDevice.currentDevice().identifierForVendor!.UUIDString,
                "arrivalTime": alarm!.valueForKey("arrival")!, // TODO: FIX FORMAT OF THE DATE OBJECT
                "didArrive": true
            ]
            
            let http = HTTP()
            let dataJSON = http.toJSON(dataDictionary)
            http.POST("URL_HERE", requestJSON: dataJSON!, postComplete: { (success: Bool, msg: String) -> () in
                // TODO: HANDLE RESPONSE HERE
            })
            break
        case "LATE_ACTION":
            print("APP DELEGATE: LATE_ACTION")
            // TODO: HTTP POST {deviceUUID, arrivalTime, didArrive = FALSE}
            
            let alarmDictionary: NSDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey("alarmItems") ?? Dictionary()
            let alarmID = notification.userInfo!["UUID"] as! String
            let alarm = alarmDictionary.valueForKey(alarmID)
            
            let dataDictionary: NSDictionary = [
                "deviceUUID": UIDevice.currentDevice().identifierForVendor!.UUIDString,
                "arrivalTime": alarm!.valueForKey("arrival")!, // TODO: FIX FORMAT OF THE DATE OBJECT
                "didArrive": false
            ]
            
            let http = HTTP()
            let dataJSON = http.toJSON(dataDictionary)
            http.POST("URL_HERE", requestJSON: dataJSON!, postComplete: { (success: Bool, msg: String) -> () in
                // TODO: HANDLE RESPONSE HERE
            })
            break
        default:
            print("ERROR HANDLING NOTIFICATION ACTIONS")
        }
        completionHandler() // per developer documentation, app will terminate if we fail to call this
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.cs5356.smart_alarm" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("smart_alarm", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

