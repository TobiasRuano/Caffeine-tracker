//
//  HomeTableViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 13/4/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import HealthKit

struct drink: Codable {
    var type: String
    var caffeineML: Int
    var caffeineOZ: Int
    var icon: String
    
    init(type: String, caffeineML: Int, caffeineOZ: Int, icon: String) {
        self.type = type
        self.caffeineML = caffeineML
        self.caffeineOZ = caffeineOZ
        self.icon = icon
    }
}

let healthKitStore: HKHealthStore = HKHealthStore()
var arrayDrinks: [drink] = []
var arrayDrinksAdded: [drink] = []
//var dicDrinksAdded: [Date: drink] = [:]

class HomeTableViewController: UITableViewController {
    
    @IBOutlet weak var addDrinksButton: UIBarButtonItem!
    var drinkAux: drink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if HKHealthStore.isHealthDataAvailable() {
            // add code to use HealthKit here...
            print("Yes, HealthKit is Available")
            let healthManager = HealthKitSetupAssistant()
            healthManager.requestPermissions()
        } else {
            print("There is a problem accessing HealthKit")
        }

        tableView.tableFooterView = UIView()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = self.addDrinksButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDrinks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = arrayDrinks[indexPath.row].type
        cell.detailTextLabel?.text = String(arrayDrinks[indexPath.row].caffeineML) + "mg of caffeine in 100ml"
        cell.imageView?.image = UIImage(named: arrayDrinks[indexPath.row].icon)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(arrayDrinks[indexPath.row].type) has \(arrayDrinks[indexPath.row].caffeineML)mg of caffeine in 100ml")
        drinkAux = arrayDrinks[indexPath.row]
        //User Defaults
        UserDefaults.standard.set(try? PropertyListEncoder().encode(drinkAux), forKey: "tosave")
        self.performSegue(withIdentifier: "ShowModalView", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print(arrayDrinks[indexPath.row].type)
        
        let alertController = UIAlertController(title: "Edit amount of caffeine", message: "Amount of caffeine in 100ml of \(arrayDrinks[indexPath.row].type):", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            // do something with textField
            
            if let number: Int = Int(textField.text!) {
                arrayDrinks[indexPath.row].caffeineML = number
            }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinks), forKey: "array")
            tableView.reloadData()
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "\(arrayDrinks[indexPath.row].caffeineML)mg"
            textField.keyboardType = UIKeyboardType.numberPad
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.drinkAux = arrayDrinks[indexPath.row]
        UserDefaults.standard.set(try? PropertyListEncoder().encode(drinkAux), forKey: "tosave")
        
        let closeAction = UIContextualAction(style: .normal, title:  "Add", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("CloseAction ...")
            self.performSegue(withIdentifier: "ShowModalView", sender: self)
            
            self.alerta(title: "Do you?", message: "Do you want to add \(arrayDrinks[indexPath.row].caffeineML)mg of caffeine from \(arrayDrinks[indexPath.row].type)", taptic: true, button1: "Yes", button2: "No", passData: true)
            success(true)
        })
        closeAction.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
    
    // Editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            // ActionSheet
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete \"\(arrayDrinks[indexPath.row].type)\" from your list?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete Drink", style: .destructive , handler:{ (UIAlertAction)in
                print("User click Delete button")
                arrayDrinks.remove(at: indexPath.row);
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                //Taptic feedback meterlo en la funcion alert
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
                
                UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinks), forKey: "array")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Cancel button")
            }))
            
            self.present(alert, animated: true, completion: {
                print("ActionSheet Shown")
            })
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let element = arrayDrinks[fromIndexPath.row]
        arrayDrinks.remove(at: fromIndexPath.row)
        arrayDrinks.insert(element, at: to.row)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinks), forKey: "array")
    }
    
    
    // MARK: - Alert Function
    func alerta(title: String, message: String, taptic: Bool, button1: String, button2: String, passData: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: button1, style: .default, handler: { alert -> Void in
            
        }))
        alertController.addAction(UIAlertAction(title: button2, style: .cancel, handler: { alert -> Void in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
 
    @IBAction func unwindFromAddVC(_ sender: UIStoryboardSegue) {
        if sender.source is AddDrinkTableViewController {
            if let senderVC = sender.source as? AddDrinkTableViewController {
                if senderVC.drinkToAdd.type != "" && senderVC.drinkToAdd.caffeineML != 0 {
                    arrayDrinks.append(senderVC.drinkToAdd)
                    print(arrayDrinks)
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinks), forKey: "array")
                    tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowModalView" {
                if let viewController = segue.destination as? PickerViewController {
                    viewController.delegate = self
                    viewController.modalPresentationStyle = .overFullScreen
                }
            }
        }
    }
}
