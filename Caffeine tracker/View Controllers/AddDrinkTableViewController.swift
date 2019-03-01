//
//  AddDrinkTableViewController.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 15/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

class AddDrinkTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var caffeineAmount: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var iconCell: UITableViewCell!
    var iconName: String = "Starbucks"
    var drinkToAdd: drink = drink(type: "", caffeineMg: 0, mililiters: 0, icon: "Latte", dia: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconCell.imageView?.image = UIImage(named: iconName)
        
        tableView.keyboardDismissMode = .interactive
        UserDefaults.standard.set("Starbucks", forKey: cellForCheckmarkKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.name.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: cellForCheckmarkKey) != nil {
            iconName = UserDefaults.standard.string(forKey: cellForCheckmarkKey)!
        }
        iconCell.imageView?.image = UIImage(named: iconName)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 && indexPath.row == 0 {
            self.view.endEditing(true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    //MARK: - Controlling the Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == name {
            textField.resignFirstResponder()
            caffeineAmount.becomeFirstResponder()
        }
        return true
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == "unwind" {
                if name.text != "" && caffeineAmount.text != "" && caffeineAmount.text?.isNumeric == true {
                    drinkToAdd.type = name.text!
                    print(name.text!)
                    drinkToAdd.caffeineMg = Int(caffeineAmount.text!)!
                    drinkToAdd.mililiters = Int(caffeineAmount.text!)!
                    drinkToAdd.icon = iconName
                    print(drinkToAdd)
                    
                    
                    //Taptic feedback
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    self.dismiss(animated: true, completion: nil)
                }
            }else if identifier == "icon" {
                let vc = segue.destination as! PickIconTableViewController
                if name.text != "" {
                    vc.objectName = name.text!
                }
                if caffeineAmount.text != "" {
                    vc.caffeine = "\(caffeineAmount.text!)mg"
                }
            }
        }
    }

}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
