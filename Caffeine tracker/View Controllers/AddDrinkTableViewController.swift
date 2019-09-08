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
    var mlUnit: Bool = true
    var drinkToAdd: drink = drink(type: "", caffeineMg: 0, mililiters: 0, icon: "Latte", dia: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconCell.imageView?.image = UIImage(named: iconName)
        tableView.keyboardDismissMode = .interactive
        UserDefaults.standard.set("Starbucks", forKey: cellForCheckmarkKey)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.name.becomeFirstResponder()
        }
        caffeineAmount.placeholder = "0"
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

    // ---- ---- ---- ----
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 && indexPath.row == 0 {
            self.view.endEditing(true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header = ""
        if section == 0 {
            header = "DRINK NAME"
        } else if section == 1 {
            switch unitGlobal {
            case .ml:
                header = "CAFFEINE IN 100ML"
            case .flOzUS:
                header = "CAFFEINE IN 3 FL OZ"
            case .flOzUK:
                header = "CAFFEINE IN 3 FL OZ"
            }
        }
        return header
    }
    
    //MARK: - Controlling the Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == name {
            textField.resignFirstResponder()
            caffeineAmount.becomeFirstResponder()
        }
        return true
    }
    
    // ----
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == unwindID {
                if name.text != "" && caffeineAmount.text != "" && caffeineAmount.text?.isNumeric == true {
                    drinkToAdd.setName(name: name.text!)
                    print(name.text!)
                    let textLabelCaffeine = Double(caffeineAmount.text!)
                    print(textLabelCaffeine!)
                    drinkToAdd.setCaffeineMg(value: textLabelCaffeine!)
                    // no importa este valor
                    drinkToAdd.setMl(value: 0.0)
                    switch unitGlobal {
                    case .ml:
                        print("\(drinkToAdd.getMl()) y \(drinkToAdd.getCaffeineMg())")
                    case .flOzUS:
                        print("\(drinkToAdd.getUSoz()) y \(drinkToAdd.getCaffeineMg())")
                    case .flOzUK:
                        print("\(drinkToAdd.getUKoz()) y \(drinkToAdd.getCaffeineMg())")
                    }
                    drinkToAdd.setIcon(imageString: iconName)
                    print(drinkToAdd)
                    TapticEffectsService.performFeedbackNotification(type: .success)
                }
            } else if identifier == iconID {
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
