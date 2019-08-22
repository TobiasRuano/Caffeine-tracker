//
//  AppDelegate.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 13/4/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    enum QuickAction: String {
        case Home = "yourDrinks"
        case History = "history"
        init?(fullIdentifier: String) {
            guard let shortcutIdentifier = fullIdentifier.components(separatedBy: ".").last else {
                return nil
            }
            self.init(rawValue: shortcutIdentifier)
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                    for purchase in purchases {
                        switch purchase.transaction.transactionState {
                        case .purchased, .restored:
                            if purchase.needsFinishTransaction {
                                // Deliver content from server, then:
                                SwiftyStoreKit.finishTransaction(purchase.transaction)
                            }
                            UserDefaults.standard.set(true, forKey: inAppPurchaseKey)
                        case .failed, .purchasing, .deferred:
                            break // do nothing
                        @unknown default:
                            fatalError()
                        }
                    }
                }
        
        if let data = UserDefaults.standard.value(forKey: arrayDrinksKey) as? Data {
            let arrayData = try? PropertyListDecoder().decode(Array<drink>.self, from: data)
            arrayDrinks = arrayData!
            print(arrayDrinks)
        }else {
            arrayDrinks.append(drink(type: "Americano", caffeineMg: 43, mililiters: 98, icon: "Starbucks", dia: nil))
            arrayDrinks.append(drink(type: "Espresso", caffeineMg: 150, mililiters: 100, icon: "cafe3", dia: nil))
            arrayDrinks.append(drink(type: "Latte", caffeineMg: 32, mililiters: 49, icon: "Starbucks", dia: nil))
            arrayDrinks.append(drink(type: "Mocha", caffeineMg: 43, mililiters: 76, icon: "Cafe", dia: nil))
            arrayDrinks.append(drink(type: "Soda", caffeineMg: 10, mililiters: 10, icon: "Can", dia: nil))
        }
        if let data = UserDefaults.standard.value(forKey: arrayDrinksAddedKey) as? Data {
            let ArrayAddedData = try? PropertyListDecoder().decode(Array<drink>.self, from: data)
            arrayDrinksAdded = ArrayAddedData!
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
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleQuickAction(shortcutItem: shortcutItem))
    }
    
    private func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = QuickAction(fullIdentifier: shortcutType)
            else {
                return false
        }
        guard let tabBarController = window?.rootViewController as? UITabBarController else {
            return false
        }
        switch shortcutIdentifier {
        case .Home:
            tabBarController.selectedIndex = 0
        case .History:
            tabBarController.selectedIndex = 1
        }
        return true
    }

}

