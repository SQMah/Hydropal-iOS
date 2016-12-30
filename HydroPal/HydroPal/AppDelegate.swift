//
//  AppDelegate.swift
//  HydroPal
//
//  Created by Shao Qian MAH on 11/11/2016.
//  Copyright © 2016 HydroPal. All rights reserved.

import Foundation
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            shiftVolumeArray()
        } else {
            // Initialising UserDefaults
            self.window = UIWindow(frame: UIScreen.main.bounds)
                    
            let welcomeView = storyboard.instantiateViewController(withIdentifier: "view1")
            self.window?.rootViewController = welcomeView
            self.window?.makeKeyAndVisible()
            
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            let birthdayString = dateFormatter.string(from: NSDate() as Date)
            let stringDate = dateFormatter.string(from: Date())
            
            defaults.set("", forKey: "serial")
            defaults.set("", forKey: "selectedSex")
            defaults.set(birthdayString, forKey: "birthday")
            defaults.set("2016-11-29 23:00:00 +GMT", forKey: "wakeTime")
            defaults.set("2016-11-30 15:00:00 +GMT", forKey: "sleepTime")
            defaults.set(true, forKey: "bottleState")
            defaults.set(["0","0","0","0"], forKey: "volumeArray")
            defaults.set(false, forKey: "customGoalSwitch")
            defaults.set("3000", forKey: "customGoal")
            defaults.set(true, forKey: "ledSwitch")
            defaults.set("60", forKey: "reminderTime")
            
            // print("Serial to \(defaults.string(forKey: "serial"))")
            // print("Sex set to \(defaults.string(forKey: "selectedSex"))")

            // Set last quit
            defaults.set(stringDate, forKey: "lastQuitDate")
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
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let stringDate = dateFormatter.string(from: Date())
        
        defaults.set(stringDate, forKey: "lastQuitDate")
        // print(defaults.string(forKey: "lastQuitDate")!)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        shiftVolumeArray()
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        //dateFormatter.calendar = Calendar(identifier: .iso8601)
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //let stringDate = dateFormatter.string(from: Date())
        //defaults.set(stringDate, forKey: "lastQuitDate")
    }
    

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let stringDate = dateFormatter.string(from: Date())
        defaults.set(stringDate, forKey: "lastQuitDate")
    }
    
    func shiftVolumeArray() {
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
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
        
        // Set lastQuit so it doesn't shift twice when HomeViewController loads
        let dateString = dateFormatter.string(from: Date())
        defaults.set(dateString, forKey: "lastQuitDate")
    }
}

