//
//  ViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 8/7/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import HealthKit

let healthKitStore: HKHealthStore = HKHealthStore()
var arrayDrinks: [drink] = []
var arrayDrinksAdded: [drink] = []

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addDrinksButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    var drinkAux: drink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkHealthAvailability()
        tableView.tableFooterView = UIView()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
//        self.navigationItem.leftBarButtonItem = self.addDrinksButton
        
        animatedView.layer.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        animatedView.layer.cornerRadius = 8.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    fileprivate func checkHealthAvailability() {
        if HKHealthStore.isHealthDataAvailable() {
            // add code to use HealthKit here...
            print("Yes, HealthKit is Available")
            let healthManager = HealthKitSetupAssistant()
            healthManager.requestPermissions()
        } else {
            print("There is a problem accessing HealthKit")
        }
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDrinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = arrayDrinks[indexPath.row].type
        cell.detailTextLabel?.text = String(arrayDrinks[indexPath.row].caffeineML) + "mg of caffeine in 100ml"
        cell.imageView?.image = UIImage(named: arrayDrinks[indexPath.row].icon)
        return cell
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(arrayDrinks[indexPath.row].type) has \(arrayDrinks[indexPath.row].caffeineML)mg of caffeine in 100ml")
        self.drinkAux = arrayDrinks[indexPath.row]
        UserDefaults.standard.set(try? PropertyListEncoder().encode(drinkAux), forKey: "tosave")
        self.performSegue(withIdentifier: "ShowModalView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.drinkAux = arrayDrinks[indexPath.row]
        UserDefaults.standard.set(try? PropertyListEncoder().encode(drinkAux), forKey: "tosave")
        
        let AddAction = UIContextualAction(style: .normal, title:  "Add", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("AddAction ...")
            self.performSegue(withIdentifier: "ShowModalView", sender: self)
            
            self.alerta(title: "Do you?", message: "Do you want to add \(arrayDrinks[indexPath.row].caffeineML)mg of caffeine from \(arrayDrinks[indexPath.row].type)", taptic: true, button1: "Yes", button2: "No", passData: true)
            success(true)
        })
        AddAction.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        return UISwipeActionsConfiguration(actions: [AddAction])
    }
    
    // Editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            // ActionSheet
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete \"\(arrayDrinks[indexPath.row].type)\" from your list?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete Drink", style: .destructive , handler:{ (UIAlertAction)in
                print("User click Delete button")
                arrayDrinks.remove(at: indexPath.row);
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                //Taptic feedback
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
    
    @IBAction func editTableView(_ sender: UIBarButtonItem) {
        let prueba = !tableView.isEditing
        tableView.setEditing(prueba, animated: true)
        
        switch tableView.isEditing {
        case true:
            editButton.title = "Done"
            editButton.style = .done
        case false:
            editButton.title = "Edit"
            editButton.style = .plain
        }
    }
    
    
    // Rearranging the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
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
    
    @IBAction func unwindFromPickerView(_ sender: UIStoryboardSegue) {
        if sender.source is PickerViewController {
            if let senderVC = sender.source as? PickerViewController {
                let healthManager = HealthKitSetupAssistant()
                
                if senderVC.seleccion != 0 {
                    senderVC.result = (senderVC.seleccion * senderVC.toSave.caffeineML) / 100
                }else {
                    senderVC.seleccion = 100
                }
                if senderVC.result != 0 {
                    senderVC.toSave.caffeineML = senderVC.result
                    let dia = Date()
                    healthManager.submitCaffeine(CaffeineAmount: senderVC.result, WaterAmount: senderVC.seleccion, forDate: dia, logWater: senderVC.waterLog)
                    arrayDrinksAdded.append(senderVC.toSave)
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinksAdded), forKey: "arrayAdded")
                    print(senderVC.toSave)
                    print(arrayDrinksAdded)
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.animatedView.transform = CGAffineTransform(translationX: 0, y: 70)
                    })
                    //Taptic feedback
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.animatedView.transform = CGAffineTransform.identity
                        })
                    }
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
