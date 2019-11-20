//
//  AppDelegate.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 13/4/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import CoreData
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
        } else {
            arrayDrinks.append(drink(type: "Americano", caffeineMg: 43, mililiters: 98, icon: "Starbucks", dia: nil))
            arrayDrinks.append(drink(type: "Espresso", caffeineMg: 150, mililiters: 100, icon: "cafe3", dia: nil))
            arrayDrinks.append(drink(type: "Latte", caffeineMg: 32, mililiters: 49, icon: "Starbucks", dia: nil))
            arrayDrinks.append(drink(type: "Mocha", caffeineMg: 43, mililiters: 76, icon: "Cafe", dia: nil))
            arrayDrinks.append(drink(type: "Soda", caffeineMg: 10, mililiters: 10, icon: "Can", dia: nil))
        }
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let data = UserDefaults.standard.value(forKey: arrayDrinksAddedKey) as? Data {
                    let ArrayAddedData = try? PropertyListDecoder().decode(Array<drink>.self, from: data)
                    arrayDrinksAdded = ArrayAddedData!
                }
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
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
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DrinkManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

