//
//  AppDelegate.swift
//  HydroPal
//
//  Created by Shao Qian MAH on 11/11/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//
// yello3

import Foundation
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            shiftVolumeArray()
        } else {
            // Initialising UserDefaults
            
            defaults.set(false, forKey: "customGoalSwitch")
            defaults.set("4000", forKey: "customGoal")
            defaults.set("Male", forKey: "selectedSex")
            defaults.set(true, forKey: "ledSwitch")
            defaults.set("60", forKey: "reminderTime")
            defaults.set("2016-11-30 23:20:00 +GMT", forKey: "wakeTime")
            defaults.set("2016-12-01 14:30:00 +GMT", forKey: "sleepTime")
            defaults.set(["1000","2000","3000","4000"], forKey: "volumeArray")
            
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            print("initialise defaults")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xx"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let stringDate = dateFormatter.string(from: Date())
        
        defaults.set(stringDate, forKey: "lastQuitDate")
        print(defaults.string(forKey: "lastQuitDate")!)
        print("Application Entered Background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        shiftVolumeArray()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xx"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let stringDate = dateFormatter.string(from: Date())
        defaults.set(stringDate, forKey: "lastQuitDate")
    }
    

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xx"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let stringDate = dateFormatter.string(from: Date())
        defaults.set(stringDate, forKey: "lastQuitDate")
        print("App will terminate")
    }
    
    func shiftVolumeArray() {
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xx"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let lastQuitString = defaults.string(forKey: "lastQuitDate")!
        let lastQuitDate = dateFormatter.date(from: lastQuitString)
        let startOfLastQuitString: String = String(describing: calendar.startOfDay(for: lastQuitDate!))
        let startOfLastQuitDate = dateFormatter.date(from: startOfLastQuitString)
        
        
        let daysSinceLastQuit = (Calendar.current.dateComponents([.day], from: startOfLastQuitDate!, to: Date()).day!)

        var volumeArray = defaults.stringArray(forKey: "volumeArray")
        if daysSinceLastQuit < 1 {
            // Don't shift
        } else if daysSinceLastQuit >= 1 && daysSinceLastQuit < 2 {
            // Shift one
            volumeArray![0] = volumeArray![1]
            volumeArray![1] = volumeArray![2]
            volumeArray![2] = volumeArray![3]
            volumeArray![3] = "0"
        } else if daysSinceLastQuit >= 2 && daysSinceLastQuit < 3 {
            // Shift twice
            volumeArray![0] = volumeArray![2]
            volumeArray![1] = volumeArray![3]
            volumeArray![2] = "0"
            volumeArray![3] = "0"
        } else if daysSinceLastQuit >= 3 && daysSinceLastQuit < 4 {
            // Shift thrice
            volumeArray![0] = volumeArray![3]
            volumeArray![1] = "0"
            volumeArray![2] = "0"
            volumeArray![3] = "0"
        } else if daysSinceLastQuit >= 4 {
            // Shift four times
            volumeArray![0] = "0"
            volumeArray![1] = "0"
            volumeArray![2] = "0"
            volumeArray![3] = "0"
        } else {
            // Do nothing
        }
        defaults.set(volumeArray, forKey: "volumeArray")
    }
}

