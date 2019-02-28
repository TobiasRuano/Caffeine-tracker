//
//  InAppPurchaseTableViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 13/4/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class InAppPurchaseTableViewController: UITableViewController {
    
    var buttonIsEnabled = true
    @IBOutlet weak var fullVersionButton: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let value = UserDefaults.standard.value(forKey: "Purchase") as? Bool {
            if value == false {
                buttonIsEnabled = value
                lockCell()
            }
        }
    }

    
    // MARK: - table view Data Source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            print("Purchase button pressed!")
            
            lockCell()
            //Taptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }else if indexPath.section == 1 && indexPath.row == 0 {
            let result = restorePurchase()
            if result == true {
                
                lockCell()
                //Taptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func lockCell() {
        fullVersionButton.detailTextLabel?.text = "Purchased!!"
        
        buttonIsEnabled = false
        UserDefaults.standard.set(buttonIsEnabled, forKey: "Purchase")
        fullVersionButton.selectionStyle = .none
        fullVersionButton.isUserInteractionEnabled = false
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 && indexPath.row == 0 {
            if buttonIsEnabled == false {
                return nil
            }
        }
        return indexPath
    }
    
    func restorePurchase() -> Bool {
        
        if buttonIsEnabled == true {
            restoreAlert(title: "Purchase Restored!", message: "Your purchase has been restored", buttonText: "Great!")
        }else {
            restoreAlert(title: "Opps!", message: "It seems there's nothing to restore", buttonText: "Ok")
        }
        
        return true
    }
    
    func restoreAlert (title: String, message: String, buttonText: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonText, style: .default, handler: { alert -> Void in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
