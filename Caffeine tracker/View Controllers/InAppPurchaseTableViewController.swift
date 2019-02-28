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

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    // MARK: - table view Data Source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            print("Purchase button pressed!")
            
            lockCell(path: indexPath)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }else if indexPath.section == 1 && indexPath.row == 0 {
            let result = restorePurchase()
            if result == true {
                var indexPathCopy = indexPath
                indexPathCopy.section = 0
                
                lockCell(path: indexPathCopy)
                buttonIsEnabled = false
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func lockCell(path: IndexPath) {
        let cell = tableView.cellForRow(at: path)
        cell?.detailTextLabel?.text = "Purchased!!"
        
        //Taptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        buttonIsEnabled = false
        cell?.selectionStyle = .none
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
        let alertController = UIAlertController(title: "Purchase Restored!", message: "Your purchase has been restored", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Great!", style: .default, handler: { alert -> Void in
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
        return true
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
