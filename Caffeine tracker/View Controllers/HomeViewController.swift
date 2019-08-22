//
//  ViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 8/7/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import HealthKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addDrinksButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var animatedViewTextLabel: UILabel!
    var drinkAux: drink?
    var hasPurchasedApp = false
    var drinksLimit: drinkLimit = drinkLimit(cant: 0, date: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkOnboardingStatus()
        checkHealthAvailability()
        loadDrinkLimitVariable()
        
        tableView.tableFooterView = UIView()
        animatedView.layer.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        animatedView.layer.cornerRadius = 8.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        //Check purchase Status
        if let purchase = UserDefaults.standard.value(forKey: inAppPurchaseKey) as? Bool {
            hasPurchasedApp = purchase
            print(hasPurchasedApp)
        }
    }
    
    func checkOnboardingStatus() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        if (UserDefaults.standard.value(forKey: "OnboardingScreen") as? Bool) == nil  {
            vc = storyBoard.instantiateViewController(withIdentifier: "OnboardingRoot")
            present(vc, animated: true, completion: nil)
        }
    }
    
    func loadDrinkLimitVariable() {
        if let data = UserDefaults.standard.value(forKey: drinkLimitKey) as? Data {
            let copy = try? PropertyListDecoder().decode(drinkLimit.self, from: data)
            drinksLimit = copy!
        }
        let date = Date()
        let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        let day = Calendar.current.dateComponents([.day, .year, .month], from: drinksLimit.date).day
        if day != calanderDate.day {
            drinksLimit.date = Date()
            drinksLimit.cant = 0
            UserDefaults.standard.set(try? PropertyListEncoder().encode(drinksLimit), forKey: drinkLimitKey)
        }
    }
    
    fileprivate func checkHealthAvailability() {
        if HKHealthStore.isHealthDataAvailable() {
            print("Yes, HealthKit is Available")
            let healthManager = HealthKitSetupAssistant()
            healthManager.requestPermissions()
        } else {
            print("There is a problem accessing HealthKit")
        }
    }
    
    // ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDrinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeTableViewCell, for: indexPath)
        cell.textLabel?.text = arrayDrinks[indexPath.row].type
        cell.detailTextLabel?.text = String(arrayDrinks[indexPath.row].caffeineMg) + "mg of caffeine in 100ml"
        cell.imageView?.image = UIImage(named: arrayDrinks[indexPath.row].icon)
        return cell
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(arrayDrinks[indexPath.row].type) has \(arrayDrinks[indexPath.row].caffeineMg)mg of caffeine in 100ml")
        self.drinkAux = arrayDrinks[indexPath.row]
        UserDefaults.standard.set(try? PropertyListEncoder().encode(drinkAux), forKey: toSaveKey)
        self.performSegue(withIdentifier: modalViewIdentifier, sender: self)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Amount of caffeine in:", message: "100ml of \(arrayDrinks[indexPath.row].type):", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            if let number: Int = Int(textField.text!) {
                arrayDrinks[indexPath.row].caffeineMg = number
            }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinks), forKey: arrayDrinksKey)
            tableView.reloadData()
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "\(arrayDrinks[indexPath.row].caffeineMg)mg"
            textField.keyboardType = UIKeyboardType.numberPad
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.drinkAux = arrayDrinks[indexPath.row]
        UserDefaults.standard.set(try? PropertyListEncoder().encode(drinkAux), forKey: toSaveKey)
        let AddAction = UIContextualAction(style: .normal, title:  "Add", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("AddAction ...")
            self.performSegue(withIdentifier: modalViewIdentifier, sender: self)
            self.alerta(title: "Do you?", message: "Do you want to add \(arrayDrinks[indexPath.row].caffeineMg)mg of caffeine from \(arrayDrinks[indexPath.row].type)", taptic: true, button1: "Yes", button2: "No", passData: true)
            success(true)
        })
        AddAction.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        return UISwipeActionsConfiguration(actions: [AddAction])
    }
    
    // Editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // ActionSheet
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete \"\(arrayDrinks[indexPath.row].type)\" from your list?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete Drink", style: .destructive , handler:{ (UIAlertAction)in
                print("User click Delete button")
                arrayDrinks.remove(at: indexPath.row);
                tableView.deleteRows(at: [indexPath], with: .automatic)
                TapticEffectsService.performFeedbackNotification(type: .warning)
                UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinks), forKey: arrayDrinksKey)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Cancel button")
            }))
            
            self.present(alert, animated: true, completion: {
            })
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
        UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinks), forKey: arrayDrinksKey)
    }
    
    func animateViewAndTapticFeedback(everythingOK: Bool) {
        if everythingOK {
            animatedViewTextLabel.text = "Caffeine Added!"
            animatedView.layer.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
            TapticEffectsService.performFeedbackNotification(type: .success)
        } else {
            animatedViewTextLabel.text = "You cannot log more drinks, Please Upgrade!"
            animatedView.layer.backgroundColor = UIColor.red.cgColor
            TapticEffectsService.performFeedbackNotification(type: .error)
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.animatedView.transform = CGAffineTransform(translationX: 0, y: 70)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            UIView.animate(withDuration: 0.5, animations: {
                self.animatedView.transform = CGAffineTransform.identity
            })
        }
    }
    
    // ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
    // MARK: - Alert Function
    func alerta(title: String, message: String, taptic: Bool, button1: String, button2: String, passData: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: button1, style: .default, handler: { alert -> Void in
        }))
        alertController.addAction(UIAlertAction(title: button2, style: .cancel, handler: { alert -> Void in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
    // MARK: - Navigation
    @IBAction func unwindFromAddVC(_ sender: UIStoryboardSegue) {
        if sender.source is AddDrinkTableViewController {
            if let senderVC = sender.source as? AddDrinkTableViewController {
                if senderVC.drinkToAdd.type != "" && senderVC.drinkToAdd.caffeineMg != 0 {
                    arrayDrinks.append(senderVC.drinkToAdd)
                    print(arrayDrinks)
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinks), forKey: arrayDrinksKey)
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
                    senderVC.result = (senderVC.seleccion * senderVC.toSave.caffeineMg) / 100
                }else {
                    senderVC.seleccion = 100
                }
                if senderVC.result != 0 {
                    let dia = Date()
                    senderVC.toSave.caffeineMg = senderVC.result
                    senderVC.toSave.mililiters = senderVC.seleccion
                    senderVC.toSave.date = dia
                    if hasPurchasedApp  || drinksLimit.cant == 0 {
                        healthManager.submitCaffeine(CaffeineAmount: senderVC.result, WaterAmount: senderVC.seleccion, forDate: dia, logWater: senderVC.waterLog)
                        arrayDrinksAdded.append(senderVC.toSave)
                        print("se va a guardar: \(senderVC.result)")
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinksAdded), forKey: arrayDrinksAddedKey)
                        drinksLimit.cant = drinksLimit.cant + 1
                        //Save drinks limit class
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(drinksLimit), forKey: drinkLimitKey)
                        animateViewAndTapticFeedback(everythingOK: true)
                    } else {
                        animateViewAndTapticFeedback(everythingOK: false)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == modalViewIdentifier {
                if let viewController = segue.destination as? PickerViewController {
                    viewController.delegate = self
                    viewController.modalPresentationStyle = .overFullScreen
                }
            }
        }
    }
}
