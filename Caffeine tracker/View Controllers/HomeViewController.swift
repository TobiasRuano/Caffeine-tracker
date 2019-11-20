//
//  ViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 8/7/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit
import HealthKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let backgroundTintView = UIView()
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addDrinksButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var animatedViewTextLabel: UILabel!
    var drinkAux: drink?
    var hasPurchasedApp = false
    
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
        colorStyle()
        if let purchase = UserDefaults.standard.value(forKey: inAppPurchaseKey) as? Bool {
            hasPurchasedApp = purchase
            print("The user has  purchased the app: \(hasPurchasedApp)")
        }
        // ---- ----
        //MARK: Debug
//                hasPurchasedApp = true
//                UserDefaults.standard.set(true, forKey: inAppPurchaseKey)
        if let value = UserDefaults.standard.value(forKey: "Units") as? Int {
            switch value {
            case 0:
                unitGlobal = Unit.ml
            case 1:
                unitGlobal = Unit.flOzUS
            case 2:
                unitGlobal = Unit.flOzUK
            default:
                unitGlobal = Unit.flOzUS
            }
            print("valor de value: \(value) valor de ml: \(unitGlobal)")
        } else {
            unitGlobal = .ml
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setBackgroundTint()
    }
    
    func colorStyle() {
        if #available(iOS 13, *) {
            view.backgroundColor = UIColor(named: "BackgroundGeneral")
            self.navigationController?.navigationBar.backgroundColor = UIColor(named: "BackgroundGeneral")
        }
    }
    
    func setBackgroundTint() {
        backgroundTintView.backgroundColor = UIColor.black
        backgroundTintView.alpha = 0
        backgroundTintView.tag = 2
        
        self.tabBarController?.view.addSubview(backgroundTintView)
        
        backgroundTintView.translatesAutoresizingMaskIntoConstraints = false
        backgroundTintView.topAnchor.constraint(equalTo: view.superview!.topAnchor).isActive = true
        backgroundTintView.bottomAnchor.constraint(equalTo: view.superview!.bottomAnchor).isActive = true
        backgroundTintView.leadingAnchor.constraint(equalTo: view.superview!.leadingAnchor, constant: 0).isActive = true
        backgroundTintView.trailingAnchor.constraint(equalTo: view.superview!.trailingAnchor, constant: 0).isActive = true
        
        backgroundTintView.isHidden = true
    }
    
    func checkOnboardingStatus() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        if (UserDefaults.standard.value(forKey: onboardingCheck) as? Bool) == nil  {
            vc = storyBoard.instantiateViewController(withIdentifier: onboardingRoot)
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
    
    private func checkHealthAvailability() {
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
        cell.textLabel?.text = arrayDrinks[indexPath.row].getName()
        var unit = ""
        switch unitGlobal {
        case .ml:
            unit = "100 ml"
        case .flOzUS:
            unit = "3 fl oz"
        case .flOzUK:
            unit = "3 fl oz"
        }
        let value = Int(arrayDrinks[indexPath.row].getCaffeineMg())
        cell.detailTextLabel?.text = String(value) + "mg of caffeine in \(unit)"
        cell.imageView?.image = UIImage(named: arrayDrinks[indexPath.row].getIcon())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let value = Int(arrayDrinks[indexPath.row].getCaffeineMg())
        print("\(arrayDrinks[indexPath.row].getName()) has \(value)mg of caffeine in 3 fl oz")
        self.drinkAux = arrayDrinks[indexPath.row]
        UserDefaults.standard.set(try? PropertyListEncoder().encode(drinkAux), forKey: toSaveKey)
        self.performSegue(withIdentifier: modalViewIdentifier, sender: self)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        var unit = ""
        var text = ""
        switch unitGlobal {
        case .ml:
            unit = "100ml"
        case .flOzUS:
            unit = "3 fl oz"
        case .flOzUK:
            unit = "3 fl oz"
        }
        let result = arrayDrinks[indexPath.row].getCaffeineMg()
        text = "\(Int(result))mg"
        let alertController = UIAlertController(title: "Amount of caffeine in:", message: "\(unit) of \(arrayDrinks[indexPath.row].getName()):", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            if let number: Double = Double(textField.text!) {
                arrayDrinks[indexPath.row].setCaffeineMg(value: number)
            }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinks), forKey: arrayDrinksKey)
            tableView.reloadData()
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = text
            textField.keyboardType = UIKeyboardType.numberPad
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.drinkAux = arrayDrinks[indexPath.row]
        UserDefaults.standard.set(try? PropertyListEncoder().encode(drinkAux), forKey: toSaveKey)
        let AddAction = UIContextualAction(style: .normal, title:  "Add", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.performSegue(withIdentifier: modalViewIdentifier, sender: self)
            self.alerta(title: "MMM...Wierd?", message: "It seems you've found a bug that I still can't crush. Dont worry, nothing's wrong 😅", taptic: true, button1: "Okey...", button2: "null", passData: true)
            success(true)
        })
        AddAction.backgroundColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        return UISwipeActionsConfiguration(actions: [AddAction])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete \"\(arrayDrinks[indexPath.row].getName())\" from your list?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
                arrayDrinks.remove(at: indexPath.row);
                tableView.deleteRows(at: [indexPath], with: .automatic)
                TapticEffectsService.performFeedbackNotification(type: .warning)
                UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinks), forKey: arrayDrinksKey)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
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
    
    func showBackgroundTint() {
        backgroundTintView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.backgroundTintView.alpha = 0.4
        }
    }
    
    func removeTintBackground() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundTintView.alpha = 0
        }) { (true) in
            self.backgroundTintView.isHidden = true
        }
    }
    
    // ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
    // MARK: - Alert Function
    func alerta(title: String, message: String, taptic: Bool, button1: String, button2: String, passData: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: button1, style: .default, handler: { alert -> Void in
        }))
        if button2 != "null" {
            alertController.addAction(UIAlertAction(title: button2, style: .cancel, handler: { alert -> Void in
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
    // MARK: - Navigation
    @IBAction func unwindFromAddVC(_ sender: UIStoryboardSegue) {
        if sender.source is AddDrinkTableViewController {
            if let senderVC = sender.source as? AddDrinkTableViewController {
                if senderVC.drinkToAdd.getName() != "" && senderVC.drinkToAdd.getCaffeineMg() != 0 {
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
                
                removeTintBackground()
                
                let healthManager = HealthKitSetupAssistant()
                if senderVC.seleccion == 0 {
                    switch unitGlobal {
                    case .ml:
                        senderVC.seleccion = 100
                    case .flOzUS:
                        senderVC.seleccion = 3
                    case .flOzUK:
                        senderVC.seleccion = 3
                    }
                }
                if senderVC.result != 0 {
                    let dia = Date()
                    senderVC.toSave.setThisCaffeineMg(value: Double(senderVC.result))
                    print(senderVC.seleccion)
                    senderVC.toSave.setMl(value: senderVC.seleccion)
                    senderVC.toSave.setDate(date: dia)
                    if hasPurchasedApp  || drinksLimit.cant == 0 {
                        healthManager.submitCaffeine(CaffeineAmount: senderVC.result, WaterAmount: Int(senderVC.seleccion), forDate: dia, logWater: senderVC.waterLog)
                        
                        // Aca estoy guardando las bebidas en la arrayDinksAdded
//                        arrayDrinksAdded.append(senderVC.toSave)
//                        UserDefaults.standard.set(try? PropertyListEncoder().encode(arrayDrinksAdded), forKey: arrayDrinksAddedKey)
                        saveDrink(drink: senderVC.toSave)
                        
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
    
    func saveDrink(drink: drink) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "DrinkCD", in: managedContext)
        let drinkObject = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        drinkObject.setValue(drink.getCaffeineMgAdded(), forKey: "caffeine")
        drinkObject.setValue(drink.getDate(), forKey: "date")
        drinkObject.setValue(drink.getIcon(), forKey: "icon")
        drinkObject.setValue(drink.getMl(), forKey: "mililiters")
        drinkObject.setValue(drink.getName(), forKey: "type")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Ocurrio un error al querer guardar la bebida: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == modalViewIdentifier {
                if let viewController = segue.destination as? PickerViewController {
                    showBackgroundTint()
                    viewController.delegate = self
                    viewController.modalPresentationStyle = .overFullScreen
                }
            }
        }
    }
}
