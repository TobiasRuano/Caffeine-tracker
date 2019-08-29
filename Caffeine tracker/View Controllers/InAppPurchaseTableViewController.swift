//
//  InAppPurchaseTableViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 13/4/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

class InAppPurchaseTableViewController: UITableViewController {
    var buttonIsEnabled = true
    let bundleID = Bundle.main.bundleIdentifier!
    let fullAppID = "FullApp"
    var sharedSecret = "0f15c2a29cf34e0ea9d484af460559f3"
    @IBOutlet weak var fullVersionButton: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !checkPurchaseStatus() {
            getInfo()
            verifyRecipt()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        checkPurchaseStatus()
    }
    
    func checkPurchaseStatus() -> Bool {
        var status = false
        if let value = UserDefaults.standard.value(forKey: inAppPurchaseKey) as? Bool {
            status = value
            if status == true {
                buttonIsEnabled = value
                lockCell()
            }
        }
        return status
    }
    
    // ----
    // MARK: - table View Data Source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            purchase()
            tableView.deselectRow(at: indexPath, animated: true)
        }else if indexPath.section == 1 && indexPath.row == 0 {
            restorePurchase()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func lockCell() {
        fullVersionButton.accessoryType = .checkmark
        fullVersionButton.detailTextLabel?.text = ""
        buttonIsEnabled = false
        UserDefaults.standard.set(!buttonIsEnabled, forKey: inAppPurchaseKey)
        fullVersionButton.isUserInteractionEnabled = false
        self.tableView.reloadData()
    }
    
    func getInfo() {
        NetworkActivityIndicationManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + fullAppID], completion: {
            result in
            NetworkActivityIndicationManager.networkOperationFinished()
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        })
    }
    
    func purchase() {
        NetworkActivityIndicationManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + fullAppID]) { result in
            if let product = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let product):
                        if product.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(product.transaction)
                        }
                        self.lockCell()
                        TapticEffectsService.performFeedbackNotification(type: .success)
                        print("Purchase Success: \(product.productId)")
                    case .error(let error):
                        switch error.code {
                        case .unknown:
                            print("Unknown error. Please contact support")
                            print(error)
                            self.alert(title: "Unknown error", message: "Please contact support", buttonText: "Ok")
                            TapticEffectsService.performTapticFeedback(from: .cancelled)
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled:
                            TapticEffectsService.performTapticFeedback(from: .cancelled)
                        case .paymentInvalid:
                            print("The purchase identifier was invalid")
                            self.alert(title: "The purchase identifier was invalid", message: "Please contact the developer", buttonText: "Ok")
                            TapticEffectsService.performTapticFeedback(from: .cancelled)
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable:
                            print("The product is not available in the current storefront")
                            self.alert(title: "Product not available", message: "The product is not available in the current storefront", buttonText: "Ok")
                            TapticEffectsService.performTapticFeedback(from: .cancelled)
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed:
                            print("Could not connect to the network")
                            self.alert(title: "Could not connect to the network", message: "Please try again later", buttonText: "Ok")
                            TapticEffectsService.performTapticFeedback(from: .cancelled)
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        default: print((error as NSError).localizedDescription)
                        }
                    }
                }
            }
            NetworkActivityIndicationManager.networkOperationFinished()
        }
    }
    
    func restorePurchase() {
        NetworkActivityIndicationManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                self.alert(title: "Opps!", message: "It seems there's a problem restoring your purchase. Please contact the developer", buttonText: "Ok")
                TapticEffectsService.performFeedbackNotification(type: .error)
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                self.alert(title: "Purchase Restored!", message: "Your purchase has been restored", buttonText: "Great!")
                TapticEffectsService.performFeedbackNotification(type: .success)
                self.lockCell()
            }
            else {
                print("Nothing to Restore")
                self.alert(title: "Opps!", message: "It seems there's nothing to restore", buttonText: "Ok")
                TapticEffectsService.performFeedbackNotification(type: .error)
            }
            NetworkActivityIndicationManager.networkOperationFinished()
        }
    }
    
    func verifyRecipt() {
        NetworkActivityIndicationManager.networkOperationStarted()
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = "\(self.bundleID).\(self.fullAppID)"
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
        NetworkActivityIndicationManager.networkOperationFinished()
    }
    
    func alert (title: String, message: String, buttonText: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonText, style: .default, handler: { alert -> Void in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
